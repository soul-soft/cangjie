package aspire_identity_server.hosting

import aspire_web_http.*

public interface IEndpointHandler {
    func handle(context: HttpContext): IEndpointResult
}