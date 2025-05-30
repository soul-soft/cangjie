package soulsoft_asp_http

import std.reflect.*
import std.collection.*

public interface IFeatureCollection <: Iterable<(TypeInfo, Any)> {
    func get<T>(): ?T
    func set<T>(value: T): Unit
}
