package soulsoft_asp_authentication_jwtbearer

import soulsoft_asp_authentication.*
import soulsoft_security_tokens_jwt.*

public class JwtBearerAuthenticationOptions <: AuthenticationSchemeOptions {
    public var saveToken = true
    public var challenge = JwtBearerAuthenticationDefaults.Scheme
    public var tokenValidationParameters: TokenValidationParameters = TokenValidationParameters()
}
