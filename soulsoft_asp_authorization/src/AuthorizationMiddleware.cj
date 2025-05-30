package soulsoft_asp_authorization

import std.collection.*
import soulsoft_asp_http.*
import soulsoft_asp_routing.*

public class AuthorizationMiddleware <: IMiddleware {
    private let _policyProvider: IAuthorizationPolicyProvider

    public init(policyProvider: IAuthorizationPolicyProvider) {
        _policyProvider = policyProvider
    }

    public func invoke(context: HttpContext, next: () -> Unit) {
        if (let Some(endpoint) <- context.getEndpoint()) {
            let authorizeData = endpoint.metadata.getOrderedMetadata<IAuthorizeData>()
            let authorizePolicies = endpoint.metadata.getOrderedMetadata<AuthorizationPolicy>()
            var policy = AuthorizationPolicy.combine(_policyProvider, authorizeData, authorizePolicies)

            if (policy.isNone()) {
                next()
                return
            }

            let policyEvaluator = context.services.getOrThrow<IPolicyEvaluator>()

        }else {
            next()
        }
    }
}
