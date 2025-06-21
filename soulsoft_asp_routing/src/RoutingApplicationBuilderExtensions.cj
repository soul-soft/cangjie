package soulsoft_asp_routing

import soulsoft_asp_http.*
import soulsoft_extensions_injection.*

public interface RoutingApplicationBuilderExtensions {
    func useRouting(): Unit
    func useEndpoints(endpoints: (EndpointRouteBuilder) -> Unit): Unit
}

extend ApplicationBuilder <: RoutingApplicationBuilderExtensions {
    public func useEndpoints(endpoints: (EndpointRouteBuilder) -> Unit): Unit {
        let builder = getOrCreateEndpointRouteBuilder()
        endpoints(builder)
        //adding endpointSources
        let routeOptions = this.applicationServices.getOrThrow<IOptions<RouteOptions>>()
        for (pattern in builder.dataSources) {
            if (!routeOptions.value.endpointDataSources.contains(pattern)) {
                routeOptions.value.endpointDataSources.add(pattern)
            }
        }
        this.useRouting()
        use(EndpointMiddleware())
    }

    public func useRouting(): Unit {
        let endpointRoutingMiddlewareKey = "__EndpointRoutingMiddleware"
        if (this.properties.contains(endpointRoutingMiddlewareKey)) {
            return
        }
        let matcher = this.applicationServices.getOrThrow<IRouter>()
        use(EndpointRoutingMiddleware(matcher))
        this.properties[endpointRoutingMiddlewareKey] = true
    }

    private func getOrCreateEndpointRouteBuilder() {
        let endpointRouteBuilderKey = "__EndpointRouteBuilder"
        if (this.properties.contains(endpointRouteBuilderKey)) {
            (this.properties[endpointRouteBuilderKey] as EndpointRouteBuilder).getOrThrow()
        } else {
            let builder = EndpointRouteBuilder(this.applicationServices)
            this.properties[endpointRouteBuilderKey] = builder
            return builder
        }
    }
}
