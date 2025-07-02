package aspire_web_mvc

import std.reflect.*
import std.collection.*
import aspire_web_routing.*
import aspire_web_mvc.routing.*
import aspire_extensions_injection.*
import aspire_web_mvc.abstractions.*

public interface ControllerEndpointRouteBuilderExtensions {
    func mapControllers(): ControllerActionEndpointConventionBuilder
}

extend EndpointRouteBuilder <: ControllerEndpointRouteBuilderExtensions {
   
    public func mapControllers() {
        let dataSource = getOrCreateEndpointDataSource(this)
        return dataSource.defaultBuilder
    }

    private func getOrCreateEndpointDataSource(endpoints: EndpointRouteBuilder): ControllerActionEndpointDataSource {
        for (pattern in dataSources) {
            if (let dataSources: ControllerActionEndpointDataSource <- pattern) {
                return dataSources
            }
        }
        let dataSource = ControllerActionEndpointDataSource(serviceProivder)
        endpoints.dataSources.add(dataSource)
        return dataSource
    }
}
