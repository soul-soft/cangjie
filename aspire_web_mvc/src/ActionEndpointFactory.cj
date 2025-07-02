package aspire_web_mvc

import std.collection.*
import aspire_web_http.*
import aspire_web_routing.*
import aspire_web_mvc.bindings.*
import aspire_web_mvc.controllers.*
import aspire_extensions_injection.*
import aspire_web_mvc.abstractions.*

class ActionEndpointFactory {
    private let _services: IServiceProvider
    private let _modelBinder: IModelBinder
    private let _controllerFactory: IControllerFactory

    public init(services: IServiceProvider, modelBinder: IModelBinder, controllerFactory: IControllerFactory) {
        _services = services
        _modelBinder = modelBinder
        _controllerFactory = controllerFactory
    }

    public func addEndpoints(endpoints: List<Endpoint>, action: ControllerActionDescriptor,
        conventions: ArrayList<(EndpointBuilder) -> Unit>) {
        let default = action.controllerType.annotations |> filterMap {f => f as IRouteTemplateProvider} |>
            filterMap {f => f.template} |> first
        let templates = action.actionFunction.annotations |> filterMap {f => f as IRouteTemplateProvider} |>
            filterMap {f => f.template}
        for (pattern in templates) {
            let template: ?String = if (pattern.startsWith('/')) {
                pattern
            } else if (let Some(default) <- default) {
                "${default}/${pattern}"
            } else {
                None
            }
            //create endpoints
            if (let Some(template) <- template) {
                let routePattern = createRoutePattern(template, action)
                let builder = createEndpointBuilder(routePattern, action)
                configureEndpointBuilder(builder, conventions)
                configureEndpointMetadata(builder, action)
                endpoints.add(builder.build())
            }
        }
    }

    private func createRoutePattern(template: String, action: ControllerActionDescriptor) {
        let path = template.replace("[controller]", action.controllerName).replace("[action]", action.actionName)
        return RoutePattern.parse(path)
    }

    private func createEndpointBuilder(routePattern: RoutePattern, action: ControllerActionDescriptor) {
        let requestDelegate = createRequestDelegate(action)
        return RouteEndpointBuilder(routePattern, requestDelegate, _services)
    }

    private func configureEndpointBuilder(
        builder: RouteEndpointBuilder,
        conventions: ArrayList<(EndpointBuilder) -> Unit>
    ) {
        for (convention in conventions) {
            convention(builder)
        }
        return builder
    }

    private func configureEndpointMetadata(builder: RouteEndpointBuilder, action: ControllerActionDescriptor) {
        builder.metadata.add(action)
        builder.metadata.add(action.endpointMetadata)
        for (pattern in action.endpointMetadata) {
            if (let httpMethodMetadata: IActionHttpMethodProvider <- pattern) {
                builder.metadata.add(HttpMethodMetadata(httpMethodMetadata.httpMethods))
            }
        }
        return builder
    }

    private func createRequestDelegate(action: ControllerActionDescriptor): RequestDelegate {
        return { context =>
            let controller = createController(context, action)
            let args = _modelBinder.bind(ModelBindingContext(context, action.actionFunction.parameters))
            let result = action.actionFunction.apply(controller, args)
            if (let actionResult : IActionResult <- result) {
                actionResult.invoke(context)
            }
        }
    }

    private func createController(httpContext: HttpContext, action: ControllerActionDescriptor) {
        return _controllerFactory.create(ControllerContext(httpContext, action))
    }
}
