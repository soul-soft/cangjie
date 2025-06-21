package soulsoft_asp_routing

import soulsoft_asp_http.*

public interface IRouter {
    func apply(context: HttpContext): RouteFlags
}
