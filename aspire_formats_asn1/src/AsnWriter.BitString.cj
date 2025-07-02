
// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

package aspire_formats_asn1

import std.math.*

extend AsnWriter {
    public func writeBisString(value: Array<Byte>, unusedBitCount!: Int64 = 0, tag!: ?Asn1Tag = None) {
        this.checkUniversalTag(tag, UniversalTagNumber.BitString)
        writeBitStringCore(tag?? Asn1Tag.PrimitiveBitString, value, unusedBitCount)
    }

    public func writeBitStringCore(tag: Asn1Tag, bitString: Array<Byte>, unusedBitCount: Int64) {
        if (unusedBitCount < 0 || unusedBitCount > 7) {
            throw IndexOutOfBoundsException()
        }

        if (bitString.size == 0 && unusedBitCount != 0) {
            throw IllegalArgumentException()
        }

        let lastByte = if (bitString.isEmpty()) {
            0u8
        }else {
            bitString[bitString.size - 1]
        }

        if (!checkValidLastByte(lastByte, unusedBitCount)) {
            throw IllegalArgumentException()
        }

        if (let CER <- this.ruleSet) {
            if (bitString.size >= Constants.MaxCERSegmentSize) {
                writeConstructedCerBitString(tag, bitString, unusedBitCount)
            }
        }
    }

    func checkValidLastByte(lastByte: Byte, unusedBitCount: Int64) {
        let mask = (1 << unusedBitCount) - 1
        return ((Int64(lastByte) & mask) == 0)
    }

    func writeConstructedCerBitString(tag: Asn1Tag, payload: Array<Byte>, unusedBitCount: Int64) {
        let MaxCERSegmentSize = Constants.MaxCERSegmentSize
        let MaxCERContentSize = MaxCERSegmentSize - 1

        let expectedSize = determineCerBitStringTotalLength(tag, payload.size)

        ensureWriteCapacity(expectedSize)

        let savedOffset = _offset

        writeTag(tag.asConstructed())
        writeLength(-1)

        let ensureNoExtraCopy = _buffer
        var remainingData = payload
        let primitiveBitString = Asn1Tag.PrimitiveBitString
        var dest: Array<Byte> = []
        while (remainingData.size > MaxCERContentSize) {
            writeTag(primitiveBitString)
            writeLength(MaxCERSegmentSize)
            _buffer.getOrThrow()[_offset] = 0
            _offset++
          
            dest = _buffer.getOrThrow()[_offset..]
            remainingData[0..MaxCERContentSize].copyTo(dest)

            remainingData = remainingData[MaxCERContentSize..]
            _offset += MaxCERContentSize
        }

        writeTag(primitiveBitString)
        writeLength(remainingData.size + 1)

        _buffer.getOrThrow()[_offset] = UInt8(unusedBitCount)
        _offset++

        dest = _buffer.getOrThrow()[_offset..]
        remainingData.copyTo(dest)
        _offset += remainingData.size

        writeEndOfContents()
    }

    func determineCerBitStringTotalLength(tag: Asn1Tag, contentLength: Int64) {
        let maxCERSegmentSize = Constants.MaxCERSegmentSize
        let maxCERContentSize = maxCERSegmentSize - 1
        let fullSegments = contentLength / maxCERContentSize
        let lastContentSize = contentLength % maxCERContentSize

        let remainingEncodedSize = if (lastContentSize == 0) {
            0
        }else {
            3 + lastContentSize + getEncodedLengthSubsequentByteCount(lastContentSize)
        }
        let FullSegmentEncodedSize = 1004
        return fullSegments + FullSegmentEncodedSize + remainingEncodedSize + 3 + tag.calculateEncodedSize()
    }
}