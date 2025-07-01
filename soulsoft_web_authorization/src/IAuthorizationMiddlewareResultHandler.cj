package soulsoft_web_authorization

import soulsoft_web_http.*

public interface IAuthorizationMiddlewareResultHandler {
    func handle(next: () -> Unit, context: HttpContext, policy: AuthorizationPolicy,
        authorizeResult: PolicyAuthorizationResult): Unit
}
