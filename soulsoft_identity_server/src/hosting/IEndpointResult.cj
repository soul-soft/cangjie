package soulsoft_identity_server.hosting

import soulsoft_web_http.*

public interface IEndpointResult {
    func execute(context: HttpContext): Unit
}