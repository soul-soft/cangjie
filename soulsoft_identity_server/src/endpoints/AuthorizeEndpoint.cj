package soulsoft_identity_server.endpoints

import soulsoft_asp_http.*


public class AuthorizeEndpoint <: EndpointHandler {
    public func handle(_: HttpContext) {
        return methodNotAllowed()
    }
}
