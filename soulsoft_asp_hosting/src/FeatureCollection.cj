package soulsoft_asp_hosting

import std.reflect.*
import std.collection.*
import soulsoft_asp_http.*

class FeatureCollection <: IFeatureCollection {
    private let _items = HashMap<TypeInfo, Any>()

    public func get<T>(): ?T {
        let typeInfo = TypeInfo.of<T>()
        if (_items.contains(typeInfo)) {
            return _items[typeInfo] as T
        }
        return None
    }

    public func set<T>(value: T) {
        let typeInfo = TypeInfo.of<T>()
        _items[typeInfo] = value
    }

    public func iterator() {
        _items.iterator()
    }
}
