package aspire_web_routing

import aspire_web_http.*

public interface IRouter {
    func apply(context: HttpContext): RouteFlags
}
