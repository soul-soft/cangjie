package soulsoft_web_routing

public interface RoutingServiceCollectionExtension {
    func addRouting(): Unit

    func addRouting(configureOptions: (RouteOptions) -> Unit): Unit
}

extend ServiceCollection <: RoutingServiceCollectionExtension {
    public func addRouting(): Unit {
        addRouting({_ =>})
    }

    public func addRouting(configureOptions: (RouteOptions) -> Unit): Unit {
        this.configure(configureOptions)

        this.tryAddSingleton(RoutingMetrics())

        this.tryAddSingleton<IRouter, Route>()

        this.tryAddSingleton<EndpointDataSource, CompositeEndpointDataSource> {
            sp => CompositeEndpointDataSource(sp.getOrThrow<IOptions<RouteOptions>>())
        }
    }
}
