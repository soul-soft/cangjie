package soulsoft_web_routing

import std.sync.*
import std.collection.*
import soulsoft_web_http.*
import soulsoft_extensions_options.*

class Route <: IRouter {
    private var _dataSource: EndpointDataSource

    public init(dataSource: EndpointDataSource) {
        _dataSource = dataSource
    }

    public func apply(context: HttpContext): RouteFlags {
        let request = RoutePattern.parse(context.request.path.value)
        let routeValues = context.request.routeValues
        var flag = RouteFlags.Notfound
        for (endpoint in _dataSource.endpoints |> filterMap {f => f as RouteEndpoint}) {
            if (tryMatch(routeValues, request, endpoint.routePattern)) {
                flag = RouteFlags.MethodNotAllowed
                if (isAllowedRequestMethod(context, endpoint)) {
                    context.setEndpoint(endpoint)
                    return RouteFlags.Ok
                }
            } else {
                routeValues.clear()
            }
        }
        return flag
    }

    private func tryMatch(routeValues: RouteValues, request: RoutePattern, pattern: RoutePattern): Bool {
        if (request.segments.size != pattern.segments.size) {
            return false
        }

        if (pattern.parameters.size == 0) {
            return request.rawText.equalsIgnoreAsciiCase(pattern.rawText)
        } else {
            for ((index, segment) in pattern.segments |> enumerate) {
                if (pattern.parameters.contains(segment)) {
                    let name = pattern.parameters[segment]
                    let value = request.segments[index]
                    routeValues.add(name, value)
                } else if (!segment.equalsIgnoreAsciiCase(request.segments[index])) {
                    return false
                }
            }
            return true
        }
    }

    private func isAllowedRequestMethod(context: HttpContext, endpoint: Endpoint) {
        if (let Some(httpMetadata) <- endpoint.metadata.getMetadata<IHttpMethodMetadata>()) {
            if (httpMetadata.httpMethods |> any {method => context.request.method.equalsIgnoreAsciiCase(method)}) {
                return true
            }
        }
        return false
    }
}
