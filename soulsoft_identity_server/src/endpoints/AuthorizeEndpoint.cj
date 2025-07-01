package soulsoft_identity_server.endpoints

import soulsoft_web_http.*
import soulsoft_identity_server.hosting.*

public class AuthorizeEndpoint <: EndpointHandler {
    public func handle(_: HttpContext) {
        return methodNotAllowed()
    }
}
