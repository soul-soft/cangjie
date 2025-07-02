package aspire_web_authentication_jwtbearer

import aspire_web_http.*

public class JwtBearerAuthenticationEvents {
    public var onMessageReceived: ?(context: HttpContext) -> ?String = None
}
