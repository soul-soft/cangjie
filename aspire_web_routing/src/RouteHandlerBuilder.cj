package aspire_web_routing

import std.collection.*

public class RouteHandlerBuilder <: EndpointConventionBuilder {
    private let _conventions: ArrayList<(EndpointBuilder) -> Unit>

    init(conventions: ArrayList<(EndpointBuilder) -> Unit>) {
        _conventions = conventions
    }

    public func add(builder: (EndpointBuilder) -> Unit) {
        _conventions.add(builder)
    }
}
