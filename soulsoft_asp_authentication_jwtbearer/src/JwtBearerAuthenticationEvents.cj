package soulsoft_asp_authentication_jwtbearer

import soulsoft_asp_http.*

public class JwtBearerAuthenticationEvents {
    public var onMessageReceived: ?(context: HttpContext) -> ?String = None
}
