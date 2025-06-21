package soulsoft_asp_authentication_jwtbearer

import soulsoft_identity_tokens.*
import soulsoft_asp_authentication.*

public class JwtBearerAuthenticationOptions <: AuthenticationSchemeOptions {
    public var saveToken = true
    public var challenge = JwtBearerAuthenticationDefaults.Scheme
    public var tokenValidationParameters: TokenValidationParameters = TokenValidationParameters()
    public let events = JwtBearerAuthenticationEvents()
}
