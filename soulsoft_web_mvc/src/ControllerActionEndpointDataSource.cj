package soulsoft_web_mvc

import std.reflect.*
import std.collection.*
import soulsoft_web_http.*
import soulsoft_web_routing.*
import soulsoft_web_mvc.routing.*
import soulsoft_web_mvc.controllers.*
import soulsoft_web_mvc.abstractions.*
import soulsoft_extensions_injection.*

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
