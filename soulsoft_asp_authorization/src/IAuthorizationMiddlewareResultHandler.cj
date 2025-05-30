package soulsoft_asp_authorization

import soulsoft_asp_http.*

public interface IAuthorizationMiddlewareResultHandler {
    func handle(next: () -> Unit, context: HttpContext, policy: AuthorizationPolicy,
        authorizeResult: PolicyAuthorizationResult): Unit
}
