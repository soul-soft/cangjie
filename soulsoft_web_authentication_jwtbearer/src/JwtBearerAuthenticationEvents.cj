package soulsoft_web_authentication_jwtbearer

import soulsoft_web_http.*

public class JwtBearerAuthenticationEvents {
    public var onMessageReceived: ?(context: HttpContext) -> ?String = None
}
