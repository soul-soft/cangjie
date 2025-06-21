package soulsoft_identity_server.hosting

import soulsoft_asp_http.*

public interface IEndpointHandler {
    func handle(context: HttpContext): IEndpointResult
}