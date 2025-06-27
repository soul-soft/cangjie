// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

package soulsoft_security_asn1

import std.io.*
import std.collection.*

public class AsnWriter {
    private var _offset: Int64 = 0
    private let _buffer: ByteBuffer
    private let _rule: AsnEncodingRules
    private let _nestingStack: ?ArrayStack<StackFrame> = None

    public init(rule: AsnEncodingRules) {
        _rule = rule
        _buffer = ByteBuffer()
    }

    public func reset() {
        if (_offset > 0) {
            _offset = 0
            _buffer.clear()
            _nestingStack.clear()
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
            throw UnsupportedException("")
        }

        if (_offset == 0) {
            return Array<Byte>()
        }

        return _buffer |> readToEnd
    }
}

struct StackFrame <: Iterable<StackFrame> {

}
