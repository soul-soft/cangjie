package soulsoft_asp_authorization

import soulsoft_asp_http.*
import soulsoft_asp_authentication.*

/*
策略执行器
*/
public interface IPolicyEvaluator {
    func authenticate(policy: AuthorizationPolicy, context: HttpContext): AuthenticateResult
    func authorize(policy: AuthorizationPolicy, authenticationResult: AuthenticateResult, context: HttpContext,
        resource: ?Object): PolicyAuthorizationResult
}
