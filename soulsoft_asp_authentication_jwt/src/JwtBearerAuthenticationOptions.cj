package soulsoft_asp_authentication_jwt

import soulsoft_security_jwt.*
import soulsoft_asp_authentication.*

public class JwtBearerAuthenticationOptions <: AuthenticationSchemeOptions {
    public var saveToken = true
    public var challenge = JwtBearerAuthenticationDefaults.Scheme
    public var tokenValidationParameters: ?TokenValidationParameters = None
}
