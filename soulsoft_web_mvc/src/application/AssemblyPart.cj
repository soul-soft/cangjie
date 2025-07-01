package soulsoft_web_mvc.application

import std.reflect.*
import std.collection.*

public class AssemblyPart <: ApplicationPart {
    private let _name: String
    private let _types: ArrayList<TypeInfo>

    public init(name: String, types: Array<TypeInfo>) {
        _name = name
        _types = ArrayList<TypeInfo>(types)
    }

    public prop name: String {
        get() {
            _name
        }
    }

    public prop types: Collection<TypeInfo> {
        get() {
            _types
        }
    }
}
