
// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

package aspire_formats_asn1

import std.math.*

extend AsnWriter {
    public func writeBoolean(value: Bool, tag!: ?Asn1Tag = None) {
        checkUniversalTag(tag, UniversalTagNumber.Boolean)

        writeBooleanCre(tag?.AsPrimitive() ?? Asn1Tag.Boolean, value)
    }

    private func writeBooleanCre(tag: Asn1Tag, value: Bool) {
        writeTag(tag)
        writeLength(1)
        _buffer.getOrThrow()[_offset] = if (value) {
            0xFF
        } else {
            0x00
        }
        _offset++;
    }
}
