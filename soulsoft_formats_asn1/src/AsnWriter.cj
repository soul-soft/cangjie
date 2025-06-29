// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

package soulsoft_formats_asn1

import std.io.*
import std.collection.*

public class AsnWriter {
    var _offset: Int64 = 0
    private let _ruleSet: AsnEncodingRules
    var _buffer: ?Array<Byte> = None
    var _nestingStack: ?ArrayStack<StackFrame> = None

    public init(ruleSet: AsnEncodingRules) {
        _ruleSet = ruleSet
    }

    public init(ruleSet: AsnEncodingRules, initialCapacity: Int64) {
        this(ruleSet)
        if (initialCapacity < 0) {
            throw IllegalArgumentException()
        }
        if (initialCapacity > 0) {
            _buffer = Array<Byte>(0, repeat: 0)
        }
    }

    public prop ruleSet: AsnEncodingRules {
        get() {
            _ruleSet
        }
    }

    public func reset() {
        if (_offset > 0) {
            _offset = 0
            _nestingStack?.clear()
        }
    }

    public func getEncodedLength() {
        if ((_nestingStack.flatMap {f => f.size} ?? 0) != 0) {
            throw UnsupportedException("")
        }

        return _offset
    }

    public func encode(): Array<Byte> {
        if ((_nestingStack.flatMap {f => f.size} ?? 0) != 0) {
            throw UnsupportedException()
        }

        if (_offset == 0) {
            return Array<Byte>()
        }
        if (let Some(buffer) <- _buffer) {
            return buffer.clone()
        }
        return []
    }

    func writeEndOfContents() {
        ensureWriteCapacity(2)
        _buffer.getOrThrow()[_offset] = 0
        _offset++
        _buffer.getOrThrow()[_offset] = 0
        _offset++
    }

    func checkUniversalTag(tag: ?Asn1Tag, universalTagNumber: UniversalTagNumber) {
        if (let Some(tag) <- tag) {
            if (tag.tagClass == TagClass.Universal && tag.tagValue != universalTagNumber.asByte()) {
                throw IllegalArgumentException()
            }
        }
    }

    func ensureWriteCapacity(pendingCount: Int64) {
        if (pendingCount < 0) {
            throw OverflowException()
        }
        if (_buffer.isNone() || _buffer.getOrThrow().size - _offset < pendingCount) {
            let BlockSize = 1024
            let blocks = (_offset + pendingCount + (BlockSize - 1)) / BlockSize
            let oldBuffer = _buffer
            let newBuffer = Array<Byte>(BlockSize * blocks, repeat: 0)
            oldBuffer?.copyTo(newBuffer)
            oldBuffer?.fill(0)
        }
    }

    func writeTag(tag: Asn1Tag) {
        var spaceRequired = tag.calculateEncodedSize()
        ensureWriteCapacity(spaceRequired)
        let written = tag.encode(_buffer.getOrThrow()[_offset.._offset + spaceRequired])
        if (written.isNone() || written.getOrThrow() != spaceRequired) {
            throw UnsupportedException()
        }
        _offset += spaceRequired
    }

    func writeLength(length: Int64) {
        let MultiByteMarker = 0x80u8
        if (length == -1) {
            ensureWriteCapacity(1)
            _buffer.getOrThrow()[_offset] = MultiByteMarker
            _offset++
            return
        }

        if (length < Int64(MultiByteMarker)) {
            ensureWriteCapacity(1 + length)
            _buffer.getOrThrow()[_offset] = UInt8(length)
            _offset++
            return
        }

        let lengthLength = getEncodedLengthSubsequentByteCount(length)

        ensureWriteCapacity(lengthLength + 1 + length)
        _buffer.getOrThrow()[_offset] = MultiByteMarker | UInt8(lengthLength)

        var idx = _offset + lengthLength

        var remaining = length
        do {
            _buffer.getOrThrow()[idx] = UInt8(remaining)
            remaining >>= 8
            idx--
        } while (remaining > 0)

        _offset += lengthLength + 1
    }

    func getEncodedLengthSubsequentByteCount(length: Int64): Int64 {
        if (length < 0) {
            throw OverflowException()
        }
        if (length <= 0x7F) {
            return 0
        }
        if (length <= Int64(Byte.Max)) {
            return 1
        }
        if (length <= Int64(UInt16.Max)) {
            return 2
        }
        if (length <= 0x00FFFFFF) {
            return 3
        }
        return 4
    }

    func popTag(tag: Asn1Tag, tagType: UniversalTagNumber, sortContents!: Bool = false) {
        if (_nestingStack.isNone() || _nestingStack.flatMap{f=>f.size} == 0) {
            throw UnsupportedException()
        }

        if (let Some(frame) <- _nestingStack.flatMap{f => f.peek()}) {
            if (frame.tag != tag || frame.itemType != tagType) {
                throw UnsupportedException()
            }
        }

        _nestingStack?.remove()

        if (sortContents) {
            sortContents()
        }
    }

    static func sortContents(buffer: Array<Byte>, start: Int64, end: Int64): Unit {
        let len = end - start
        
        if (len == 0) {
            return
        }

        let reader = AsnWriter()
    }

    func pushTag(tag: Asn1Tag, tagType: UniversalTagNumber) {
        _nestingStack = _nestingStack ?? ArrayStack<StackFrame>()
        writeTag(tag)
        _nestingStack?.add(StackFrame(tag, _offset, tagType))
        writeLength(-1)
        return Scope(this)
    }
}

struct StackFrame <: Equal<StackFrame> {
    private let _tag: Asn1Tag
    private let _offset: Int64
    private let _itemType: UniversalTagNumber

    init(tag: Asn1Tag, offset: Int64, itemType: UniversalTagNumber) {
        _tag = tag
        _offset = offset
        _itemType = itemType
    }

    public prop tag: Asn1Tag {
        get() {
            _tag
        }
    }

    public prop offset: Int64 {
        get() {
            _offset
        }
    }

    public prop itemType: UniversalTagNumber {
        get() {
            _itemType
        }
    }

    public operator func ==(oth: StackFrame) {
        return _tag == oth._tag && _offset == oth._offset && _itemType == oth._itemType
    }
}
