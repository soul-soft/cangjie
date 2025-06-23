/*
    https://lapo.it/asn1js/
 */

package soulsoft_identity_tokens

import std.convert.*
import std.collection.*

public class Asn1 {
    public static func parse(data: Array<Byte>) {
        let (entry, _) = parseNode(data)
        return entry
    }

    private static func parseNode(data: Array<Byte>): (Asn1Entry, Int64) {
        var offset = 0
        let tag = data[offset]
        offset += 1

        let (length, lengthBytes) = readLength(data[offset..])
        offset += lengthBytes

        let value = data[offset..offset + length]
        let entry = Asn1Entry(tag, value)
        offset += length

        if (entry.isConstructed) {
            var childOffset = 0
            while (childOffset < value.size) {
                let (child, childBytes) = parseNode(value[childOffset..])
                entry.addChild(child)
                childOffset += childBytes
            }
        }

        return (entry, offset)
    }

    private static func readLength(data: Array<Byte>): (length: Int64, lengthBytes: Int64) {
        var lengthBytes = 0
        if ((data[0] & 0x80) == 0) {
            lengthBytes = 1
            return (Int64(data[0]), lengthBytes)
        }
        let numBytes = Int64(data[0] & 0x7F)
        if (numBytes == 0 || numBytes > 4) {
            throw IllegalFormatException("Invalid ASN.1 length encoding.")
        }
        var length = 0
        for (i in 1..numBytes + 1) {
            length = (length << 8) | Int64(data[i])
        }
        lengthBytes = 1 + numBytes
        return (length, lengthBytes)
    }
}

public class Asn1Entry <: ToString {
    private let _tag: Byte
    private let _data: Array<Byte>
    private let _children = ArrayList<Asn1Entry>()

    init(tag: Byte, data: Array<Byte>) {
        _tag = tag
        _data = data
    }

    func addChild(entries: Array<Asn1Entry>) {
        _children.add(all: entries)
    }

    public prop tag: Byte {
        get() {
            _tag
        }
    }

    public prop tagName: String {
        get() {
            match (_tag) {
                case 0x01 => "BOOLEAN"
                case 0x02 => "INTEGER"
                case 0x03 => "BIT STRING"
                case 0x04 => "OCTET STRING"
                case 0x05 => "NULL"
                case 0x06 => "OBJECT IDENTIFIER"
                case 0x0C => "UTF8String"
                case 0x13 => "PrintableString"
                case 0x16 => "IA5String"
                case 0x17 => "UTCTime"
                case 0x18 => "GeneralizedTime"
                case 0x30 => "SEQUENCE"
                case 0x31 => "SET"
                case _ => "UNKNOWN(${tag.format("02X")})"
            }
        }
    }

    public prop data: Array<Byte> {
        get() {
            _data
        }
    }

    public prop isConstructed: Bool {
        get() {
            (tag & 0x20) != 0 || tag == 0x30
        }
    }

    public prop children: ReadOnlyList<Asn1Entry> {
        get() {
            _children
        }
    }

    public func toString() {
        format(0)
    }

    private func format(indent: Int64): String {
        let sb = StringBuilder()
        let indentStr = " " * (indent * 2)
        sb.append("${indentStr}- ${tagName} (0x${tag.format("02X")})\r\n")

        if (data.size > 0) {
            let hexArray = this._data |> map {f => f.format("02X")} |> collectArray
            let hexText = String.join(hexArray, delimiter: " ")
            sb.append("${indentStr}  Data: ${hexText}\r\n")
        }

        for (child in children) {
            sb.append(child.format(indent + 1))
        }

        return sb.toString()
    }

    public func findFirst(tag: Byte) {
        return find(tag) |> first
    }

    public func find(tag: Byte) {
        let result = ArrayList<Array<Byte>>()
        if (this.tag == tag) {
            result.add(this.data)
        }
        let children = findChildren(tag, _children)
        if (children.size > 0) {
            result.add(all: children)
        }
        return result
    }

    private func findChildren(tag: Byte, children: Collection<Asn1Entry>): Collection<Array<Byte>> {
        let result = ArrayList<Array<Byte>>()
        for (pattern in children) {
            if (pattern.tag == tag) {
                result.add(pattern.data)
            }
            let children = findChildren(tag, pattern.children)
            if (children.size > 0) {
                result.add(all: children)
            }
        }
        return result
    }
}
