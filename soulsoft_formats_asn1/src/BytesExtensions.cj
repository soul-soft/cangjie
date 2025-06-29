package soulsoft_formats_asn1

import std.collection.*

extend Array<Byte>{
    public func overlaps(other: Array<Byte>): ?Int64 {
        if (!refEq(this, other)) {
            return None
        }
        return None
    }
}