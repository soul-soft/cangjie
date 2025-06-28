
// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

package soulsoft_formats_asn1

import std.math.*

extend AsnWriter {
    public func writeInteger(value: Int64, tag!: ?Asn1Tag = None) {
        checkUniversalTag(tag, UniversalTagNumber.Integer)
        writeIntegerCore(tag?.AsPrimitive() ?? Asn1Tag.Integer, value)
    }

    public func writeInteger(value: UInt64, tag!: ?Asn1Tag = None) {
        checkUniversalTag(tag, UniversalTagNumber.Integer)
        writeNonNegativeIntegerCore(tag?.AsPrimitive() ?? Asn1Tag.Integer, value)
    }

    private func writeIntegerCore(tag: Asn1Tag, value: Int64) {
        if (value >= 0) {
            writeNonNegativeIntegerCore(tag, UInt64(value))
            return
        }

        let valueLength = if (value >= -128) {
            1
        } else if (value >= -32768) {
            2
        } else if (value >= -8388608) {
            3
        } else if (value >= -2147483648) {
            4
        } else if (value >= -549755813888) {
            5
        } else if (value >= -140737488355328) {
            6
        } else if (value >= -36028797018963968) {
            7
        } else {
            8
        }

        writeTag(tag)
        writeLength(valueLength)

        var remaining = value
        var idx = _offset + valueLength - 1

        do {
            _buffer.getOrThrow()[idx] = UInt8(remaining)
            remaining >>= 8
            idx--
        } while (idx >= _offset)

        _offset += valueLength
    }

    private func writeNonNegativeIntegerCore(tag: Asn1Tag, value: UInt64) {
        let valueLength = if (value < 0x80) {
            1
        } else if (value < 0x8000) {
            2
        } else if (value < 0x800000) {
            3
        } else if (value < 0x80000000) {
            4
        } else if (value < 0x80_00000000) {
            5
        } else if (value < 0x8000_00000000) {
            6
        } else if (value < 0x800000_00000000) {
            7
        } else if (value < 0x80000000_00000000) {
            8
        } else {
            9
        }

          writeTag(tag)
        writeLength(valueLength)

        var remaining = value
        var idx = _offset + valueLength - 1

        do {
            _buffer.getOrThrow()[idx] = UInt8(remaining)
            remaining >>= 8
            idx--
        } while (idx >= _offset)

        _offset += valueLength
    }
}
