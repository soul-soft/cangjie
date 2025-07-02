package aspire_identity_server.hosting

import aspire_web_http.*

public interface IEndpointRouter {
    func routing(context: HttpContext): ?IEndpointHandler
}