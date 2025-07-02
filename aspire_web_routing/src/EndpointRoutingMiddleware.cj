package aspire_web_routing

import std.collection.*

public class EndpointRoutingMiddleware <: IMiddleware {
    private let _matcher: IRouter

    init(matcher: IRouter) {
        _matcher = matcher
    }

    public func invoke(context: HttpContext, next: () -> Unit): Unit {
        var flag = RouteFlags.Notfound
        if (context.getEndpoint().isNone()) {
            flag = _matcher.apply(context)
        } else {
            flag = RouteFlags.Ok
        }
        match (flag) {
            case MethodNotAllowed => context.response.status(HttpStatusCode.MethodNotAllowed)
            case _ => next()
        }
    }
}
