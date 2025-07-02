package aspire_web_authorization

import aspire_web_http.*
import aspire_web_authentication.*

/*
策略执行器
*/
public interface IPolicyEvaluator {
    func authenticate(policy: AuthorizationPolicy, context: HttpContext): AuthenticateResult
    func authorize(policy: AuthorizationPolicy, authenticationResult: AuthenticateResult, context: HttpContext,
        resource: ?Object): PolicyAuthorizationResult
}
