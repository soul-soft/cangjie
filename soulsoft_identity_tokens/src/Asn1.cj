package soulsoft_identity_tokens

import std.convert.*
import std.collection.*

public class Asn1 {

    public static func parse(bytes: Array<Byte>) {
        var i = 0
        let root = AsnEntry(0)  
        while (i < bytes.size) {
            let tag = bytes[i]
            let offset = Int64(bytes[i + 1])
            let data = bytes[i + 2..i + 2 + offset]
            let node = AsnEntry(tag, data)
            if (tag == 0x30) {
                node.add(parseChildren(bytes[i + 2..i + 2 + offset]))
            }
            root.add(node)
            i += 2 + offset
        }  

        if (root.children.size == 1) {
            return root.children[0]
        }

        return root
    }

    private static func parseChildren(bytes: Array<Byte>) : Array<AsnEntry> {
        var i = 0
        let children = ArrayList<AsnEntry>()
        while (i < bytes.size) {
            let tag = bytes[i]
            let offset = Int64(bytes[i + 1])
            let data = bytes[i + 2..i + 2 + offset]
            let node = AsnEntry(tag, data)

            if (tag == 0x30) {
                node.add(parseChildren(bytes[i + 2..i + 2 + offset]))
            }
            children.add(node)
            i += 2 + offset
        }
        return children |> collectArray  
    }
}


public class AsnEntry <: ToString {
    private let _tag: Byte
    private let _data: Array<Byte>
    private let _children = ArrayList<AsnEntry>()

    init(tag: Byte, data: Array<Byte>) {
        _tag = tag
        _data = data
    }

    func add(entries: Array<AsnEntry>) {
        _children.add(all: entries)
    }

    public prop tag: Byte {
        get() {
            _tag
        }
    }

    public prop tagName: String {
        get() {
            if (_tag == 0x30) {
                "SEQUENCE"
            }else if (_tag == 0x01) {
                "BOOLEAN"
            }else if (_tag == 0x02) {
                "INTEGER"
            }else if (_tag == 0x03) {
                "BIT STRING"
            }else if (_tag == 0x04) {
                "OCTET STRING"
            }else if (_tag == 0x05) {
                "NULL"
            }else if (_tag == 0x06) {
                "OBJECT IDENTIFIER"
            }else if(_tag == 0x0C) {
                "UNKNOWN(${tag.format("02X")})"
            }else {
                "UNKNOWN(${tag.format("02X")})"
            }
        }
    }

    public prop data: Array<Byte> {
        get() {
            _data
        }
    }

    public prop children: ReadOnlyList<AsnEntry> {
        get() {
            _children
        }
    }

    public func toString() {
        let dataHex = String.join(_data |> map{f => f.format("02X")} |> collectArray, delimiter: ' ')
        return "${tagName}: ${dataHex}"
    }


    public func print() {
        println(this)
        printChildren(children)
    }

    private func printChildren(entries: Collection<AsnEntry>): Unit {
        for (pattern in entries) {
            printChildren(pattern.children)
            println(pattern)
        }
    }
}