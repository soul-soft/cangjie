package aspire_identity_server.endpoints

import aspire_web_http.*
import aspire_identity_server.hosting.*

public class AuthorizeEndpoint <: EndpointHandler {
    public func handle(_: HttpContext) {
        return methodNotAllowed()
    }
}
