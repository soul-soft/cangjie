package aspire_web_mvc

import std.reflect.*
import std.collection.*
import aspire_web_http.*
import aspire_web_routing.*
import aspire_web_mvc.routing.*
import aspire_web_mvc.controllers.*
import aspire_web_mvc.abstractions.*
import aspire_extensions_injection.*

class ControllerActionEndpointDataSource <: ActionEndpointDataSourceBase {
    public init(services: IServiceProvider) {
        super(services)
    }

    protected func createEndpoints(
        actions: ReadOnlyList<ControllerActionDescriptor>,
        conventions: ArrayList<(EndpointBuilder) -> Unit>
    ): ReadOnlyList<Endpoint> {
        let actionEndpointFactory = services.getOrThrow<ActionEndpointFactory>()
        let endpoints = ArrayList<Endpoint>()
        for (action in actions) {
            actionEndpointFactory.addEndpoints(endpoints, action, conventions)
        }
        return endpoints
    }
}
