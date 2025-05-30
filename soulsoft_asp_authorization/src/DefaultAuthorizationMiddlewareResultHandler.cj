package soulsoft_asp_authorization

import soulsoft_asp_http.*
import soulsoft_asp_authentication.*

public class DefaultAuthorizationMiddlewareResultHandler <: IAuthorizationMiddlewareResultHandler {
    public func handle(next: () -> Unit, context: HttpContext, policy: AuthorizationPolicy,
        authorizeResult: PolicyAuthorizationResult): Unit {
        if (authorizeResult.succeeded) {
            next()
            return
        } else if (authorizeResult.challenged) { //401
            if (policy.authenticationSchemes.size > 0) {
                for (pattern in policy.authenticationSchemes) {
                    context.challenge(pattern)
                }
            } else {
                context.challenge()
            }
        } else if (authorizeResult.forbidden) {
            if (policy.authenticationSchemes.size > 0) {
                for (pattern in policy.authenticationSchemes) {
                    context.forbid(pattern)
                }
            } else {
                context.forbid()
            }
        }
    }
}
