package soulsoft_asp_authentication

import soulsoft_asp_http.*

public interface IAuthenticationHandler {
    func initialize(scheme: AuthenticationScheme, context: HttpContext): Unit
    func authenticate(): AuthenticateResult
    func challenge(properties: ?AuthenticationProperties): Unit
    func forbid(properties: ?AuthenticationProperties): Unit
}
