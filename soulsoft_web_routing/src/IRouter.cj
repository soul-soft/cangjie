package soulsoft_web_routing

import soulsoft_web_http.*

public interface IRouter {
    func apply(context: HttpContext): RouteFlags
}
