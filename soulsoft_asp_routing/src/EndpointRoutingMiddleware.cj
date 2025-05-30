package soulsoft_asp_routing

import std.collection.*

public class EndpointRoutingMiddleware <: IMiddleware {
    private let _matcher: IRouteMatcher

    init(matcher: IRouteMatcher) {
        _matcher = matcher
    }

    public func invoke(context: HttpContext, next: () -> Unit): Unit {
        var flag = RouteMatchingFlags.Notfound
        if (context.getEndpoint().isNone()) {
            flag = _matcher.apply(context)
        } else {
            flag = RouteMatchingFlags.Ok
        }
        match (flag) {
            case MethodNotAllowed => context.response.status(HttpStatusCode.STATUS_METHOD_NOT_ALLOWED)
            case _ => next()
        }
    }
}
