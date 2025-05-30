package soulsoft_asp_routing

import std.sync.*
import std.collection.*
import soulsoft_asp_http.*
import soulsoft_extensions_options.*

class RouteMatcher <: IRouteMatcher {
    private var _dataSource: EndpointDataSource

    public init(dataSource: EndpointDataSource) {
        _dataSource = dataSource
    }

    public func apply(context: HttpContext): RouteMatchingFlags {
        let request = RoutePattern.parse(context.request.url.path)
        let routeValues = context.request.routeValues
        var flag = RouteMatchingFlags.Notfound
        for (endpoint in _dataSource.endpoints |> filterMap {f => f as RouteEndpoint}) {
            if (tryMatch(routeValues, request, endpoint.routePattern)) {
                flag = RouteMatchingFlags.MethodNotAllowed
                if (checkRequestMethod(context, endpoint)) {
                    context.setEndpoint(endpoint)
                    return RouteMatchingFlags.Ok
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

    private func checkRequestMethod(context: HttpContext, endpoint: Endpoint) {
        if (let Some(httpMetadata) <- endpoint.metadata.getMetadata<IHttpMethodMetadata>()) {
            if (httpMetadata.httpMethods |> any {method => context.request.method.equalsIgnoreAsciiCase(method)}) {
                return true
            }
        }
        return false
    }
}
