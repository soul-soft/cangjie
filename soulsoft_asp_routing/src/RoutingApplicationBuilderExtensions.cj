package soulsoft_asp_routing

import soulsoft_asp_http.*
import soulsoft_extensions_injection.*

public interface RoutingApplicationBuilderExtensions {
    /*注册路由中间件*/
    func useRouting(): Unit
    /*注册终结点及终结点中间件，如果未注册路由中间件那么自动注册*/
    func useEndpoints(endpoints: (EndpointRouteBuilder) -> Unit): Unit
}

extend ApplicationBuilder <: RoutingApplicationBuilderExtensions {
    public func useEndpoints(endpoints: (EndpointRouteBuilder) -> Unit): Unit {
        checkRequiredServices()
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

    //项目启动过程检测是否注册路由所需的服务
    private func checkRequiredServices() {
       try(scope = this.applicationServices.createScope()) {
            if (scope.services.getOrDefault<RoutingMetrics>().isNone()) {
                throw Exception("Unable to find the required services. Please add all the required services by calling 'IServiceCollection.addRouting' in the application startup code.")
            }
       }
    }
}
