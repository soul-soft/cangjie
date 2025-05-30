package soulsoft_asp_authorization

import std.collection.*
import soulsoft_asp_http.*
import soulsoft_security_claims.*
import soulsoft_asp_authentication.*

public class DefaultPolicyEvaluator <: IPolicyEvaluator {
    private let _authorizationService: IAuthorizationService

    public init(authorizationService: IAuthorizationService) {
        _authorizationService = authorizationService
    }

    public func authenticate(policy: AuthorizationPolicy, context: HttpContext): AuthenticateResult {
        if (policy.authenticationSchemes.size > 0) {
            var newPrincipal: ?ClaimsPrincipal = None
            for (scheme in policy.authenticationSchemes) {
                let result = context.authenticate(scheme)
                if (result.succeeded) {
                    newPrincipal = SecurityHelper.mergeUserPrincipal(newPrincipal, result.principal)
                }
            }
            if (let Some(newPrincipal) <- newPrincipal) {
                context.user = newPrincipal
                let ticket = AuthenticationTicket(newPrincipal,
                    String.join(policy.authenticationSchemes |> collectArray, delimiter: ";"))
                return AuthenticateResult.success(ticket)
            } else {
                context.user = ClaimsPrincipal(ClaimsIdentity())
                return AuthenticateResult.noResult()
            }
        }

        if (let Some(authenticateResultFeature) <- context.features.get<IAuthenticateResultFeature>()) {
            return authenticateResultFeature.result
        } else {
            if (context.user.identity.flatMap {f => f.isAuthenticated} ?? false) {
                return AuthenticateResult.success(AuthenticationTicket(context.user, "context.user"))
            } else {
                return AuthenticateResult.noResult()
            }
        }
    }

    public func authorize(policy: AuthorizationPolicy, authenticationResult: AuthenticateResult, context: HttpContext,
        resource: ?Object): PolicyAuthorizationResult {
        let result = _authorizationService.authorize(context.user, resource, policy)
      
        if (result.succeeded) {
            return PolicyAuthorizationResult.success()
        }

        if (authenticationResult.succeeded) {
            return PolicyAuthorizationResult.forbid(result.failure)
        }else {
            return PolicyAuthorizationResult.challenge()
        }
    }
}
