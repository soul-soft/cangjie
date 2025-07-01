package soulsoft_identity_server.hosting

import soulsoft_web_http.*

public interface IEndpointRouter {
    func routing(context: HttpContext): ?IEndpointHandler
}