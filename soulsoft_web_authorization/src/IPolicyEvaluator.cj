package soulsoft_web_authorization

import soulsoft_web_http.*
import soulsoft_web_authentication.*

/*
策略执行器
*/
public interface IPolicyEvaluator {
    func authenticate(policy: AuthorizationPolicy, context: HttpContext): AuthenticateResult
    func authorize(policy: AuthorizationPolicy, authenticationResult: AuthenticateResult, context: HttpContext,
        resource: ?Object): PolicyAuthorizationResult
}
