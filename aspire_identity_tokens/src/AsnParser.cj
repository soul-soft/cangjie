/*
    https://lapo.it/asn1js/
 */

package aspire_identity_tokens

import std.convert.*
import std.collection.*

public class AsnParser {
    private var _position: Int64
    private let _data: Array<Byte>

    private init(data: Array<Byte>) {
        _data = data
        _position = 0
    }

    public static func parse(data: Array<Byte>) {
        return AsnParser(data).parseNode()
    }

    private func parseNode(): AsnNode {
        let tag = _data[_position]
        _position += 1
        let length = calcLength()
        let value = _data[_position.._position + length]
        _position += length

        let node = AsnNode(tag, value)

        if (node.isConstructed) {
            let childParser = AsnParser(value)
            while (!childParser.isEnd) {
                node.addChild(childParser.parseNode())
            }
        } else if (tag == 0x03 || tag == 0x04) {
            let innerOffset = if (tag == 0x03) {
                1
            } else {
                0
            }
            let innerSpan = value[innerOffset..]
            if (looksLikeAsn1Structure(innerSpan)) {
                try {
                    let innerParser = AsnParser(innerSpan)
                    node.addChild(innerParser.parseNode())
                } catch (_: Exception) {
                }
            }
        }
        return node
    }

    private static func looksLikeAsn1Structure(data: Array<Byte>) {
        if (data.size < 2) {
            return false
        }
        let possibleTag = data[0]
        return possibleTag == 0x30 || possibleTag == 0x31 || (possibleTag & 0x20) != 0
    }

    private func calcLength(): Int64 {
        let first = Int64(_data[_position])
        _position += 1
        if ((first & 0x80) == 0) {
            return first
        }

        let numBytes = first & 0x7F
        if (numBytes == 0 || numBytes > 4) {
            throw IllegalFormatException("Invalid ASN.1 length encoding.");
        }

        var length = 0

        for (_ in 0..numBytes) {
            length = (length << 8) | Int64(_data[_position])
            _position += 1
        }
        return length
    }

    public prop isEnd: Bool {
        get() {
            _position >= _data.size
        }
    }
}

public class AsnNode {
    private let _children = ArrayList<AsnNode>()

    AsnNode(
        public let tag: Byte,
        public let data: Array<Byte>
    ) {
    }

    public prop children: ReadOnlyList<AsnNode> {
        get() {
            _children
        }
    }

    func addChild(node: AsnNode) {
        _children.add(node)
    }

    public prop tagName: String {
        get() {
            match (tag) {
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

    public prop isConstructed: Bool {
        get() {
            return (tag & 0x20) != 0 || tag == 0x30 || tag == 0x31
        }
    }

    private func print(indent: Int64): Unit {
        let indentStr = ' ' * (indent * 2)
        let hexData = data |> map {f => f.format("02X")} |> collectArray
        let hexText = String.join(hexData, delimiter: ' ')
        println("${indentStr}- ${tagName} (0x${tag.format('02X')})")

        if (data.size > 0) {
            println("${indentStr}  DATA: ${hexText}")
        }

        for (pattern in children) {
            pattern.print(indent + 1)
        }
    }

    public func print() {
        print(0)
    }

    public func toHashMap() {
        let hashMap = HashMap<String, Array<Byte>>()
        buildHashMap(this, hashMap, "00")
        return hashMap
    }

    
    private func buildHashMap(node: AsnNode, hashMap: HashMap<String, Array<Byte>>, path: String): Unit {
        if (data.size > 0) {
            hashMap[path] = node.data
        }

        for (i in 0..node.children.size) {
            let child = node.children[i]
            let childPath = if (node.children.size > 1) {
                "${path}:${child.tag.format('02X')}:${i}"
            }else {
                "${path}:${child.tag.format('02X')}"
            }
            buildHashMap(child, hashMap, childPath)
        }
    }
}
