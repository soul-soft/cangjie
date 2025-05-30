package soulsoft_asp_routing

import soulsoft_asp_http.*

public interface IRouteMatcher {
    func apply(context: HttpContext): RouteMatchingFlags
}
