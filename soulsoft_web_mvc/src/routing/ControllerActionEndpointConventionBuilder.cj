package soulsoft_web_mvc.routing

import std.sync.*
import std.collection.*
import soulsoft_web_http.*

public class ControllerActionEndpointConventionBuilder <: EndpointConventionBuilder {
    private let _lock: Mutex
    private let _conventions: ArrayList<(EndpointBuilder) -> Unit>

    init(lock: Mutex, conventions: ArrayList<(EndpointBuilder) -> Unit>) {
        _lock = lock
        _conventions = conventions
    }

    public func add(builder: (EndpointBuilder) -> Unit): Unit {
        synchronized(_lock) {
            _conventions.add(builder)
        }
    }
}
