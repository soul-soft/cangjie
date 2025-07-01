package soulsoft_web_routing

import std.collection.*

public class RouteEndpoint <: Endpoint {
    private let _routePattern: RoutePattern

    init(routePattern: RoutePattern, delegate: RequestDelegate, metadata: EndpointMetadataCollection, displayName: ?String) {
        super(delegate, metadata, displayName)
        _routePattern = routePattern
    }

    public prop routePattern: RoutePattern {
        get() {
            _routePattern
        }
    }
}
