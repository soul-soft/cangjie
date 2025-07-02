package aspire_web_routing

import std.collection.*

public class RouteEndpointDataSource <: EndpointDataSource {
    private let _services: IServiceProvider
    private var _endpoints: ?ArrayList<Endpoint> = None
    private let _routeEntries = ArrayList<RouteEntry>()

    init(services: IServiceProvider) {
        _services = services
    }

    public prop endpoints: ReadOnlyList<Endpoint> {
        get() {
            if (let Some(endpoints) <- _endpoints) {
                return endpoints
            } else {
                let endpoints = ArrayList<Endpoint>()
                for (pattern in _routeEntries) {
                    let builder = createRouteEndpointBuilder(pattern)
                    endpoints.add(builder.build())
                }
                _endpoints = endpoints
                return endpoints
            }
        }
    }

    public func addRequestDelegate(routePattern: String, delegate: RequestDelegate, method: String) {
        let conventions = ArrayList<(EndpointBuilder) -> Unit>()
        _routeEntries.add(RouteEntry(routePattern, delegate, method, conventions))
        return RouteHandlerBuilder(conventions)
    }

    private func createRouteEndpointBuilder(entry: RouteEntry) {
        let routePattern = RoutePattern.parse(entry.routePattern)
        let builder = RouteEndpointBuilder(routePattern, entry.delegate, _services)
        builder.metadata.add(HttpMethodMetadata(entry.method))
        for (pattern in entry.conventions) {
            pattern(builder)
        }
        return builder
    }
}

struct RouteEntry {
    public let routePattern: String
    public let delegate: RequestDelegate
    public let method: String
    public let conventions: ArrayList<(EndpointBuilder) -> Unit>

    init(routePattern: String, delegate: RequestDelegate, method: String,
        conventions: ArrayList<(EndpointBuilder) -> Unit>) {
        this.routePattern = routePattern
        this.delegate = delegate
        this.method = method
        this.conventions = conventions
    }
}
