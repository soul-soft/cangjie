package soulsoft_asp_authorization

import std.collection.*
import soulsoft_asp_http.*
import soulsoft_asp_routing.*
import soulsoft_asp_authentication.*
import soulsoft_extensions_options.*

public class AuthorizationMiddleware <: IMiddleware {
    private let _options: AuthorizationOptions

    public init(options: IOptions<AuthorizationOptions>) {
        _options = options.value
    }

    public func invoke(context: HttpContext, next: () -> Unit) {
  
        if (let Some(endpoint) <- context.getEndpoint()) {
            //authenticate
            if (let Some(policy) <- getPolicy(context, endpoint)) {
                let policyEvaluator = context.services.getOrThrow<IPolicyEvaluator>()
                let authenticateResult = authenticate(context, policy, policyEvaluator)
                if (let Some(_) <- endpoint.metadata.getMetadata<IAllowAnonymous>()) {
                    next()
                    return
                }
               
                //authorize
                let authorizeResult = policyEvaluator.authorize(policy, authenticateResult, context, if (_options.suppressUseHttpContextAsAuthorizationResource) {
                    context
                } else {
                    endpoint
                })

                //handle authorize result
                let authorizationMiddlewareResultHandler = context.services.getOrThrow<IAuthorizationMiddlewareResultHandler>()
                authorizationMiddlewareResultHandler.handle(next, context, policy, authorizeResult)
            } else {
                next()
                return
            }
        }else {
            next()
        }
    }

    private func getPolicy(context: HttpContext, endpoint: Endpoint) {
        let policyProvider = context.services.getOrThrow<IAuthorizationPolicyProvider>()
        let authorizeData = endpoint.metadata.getOrderedMetadata<IAuthorizeData>()
        let authorizePolicies = endpoint.metadata.getOrderedMetadata<AuthorizationPolicy>()
        var policy = AuthorizationPolicy.combine(policyProvider, authorizeData, authorizePolicies)

        let requirementData = endpoint.metadata.getOrderedMetadata<IAuthorizationRequirementData>()

        if (requirementData.size > 0) {
            let policyBuilder = AuthorizationPolicyBuilder()
            for (pattern in requirementData |> flatMap {f => f.getRequirements()}) {
                policyBuilder.addRequirements(pattern)
            }
            policy = if (let Some(policy) <- policy) {
                AuthorizationPolicy.combine(policy, policyBuilder.build())
            } else {
                policyBuilder.build()
            }
        }
        return policy
    }

    private func authenticate(context: HttpContext, policy: AuthorizationPolicy, policyEvaluator: IPolicyEvaluator) {
        let authenticateResult = policyEvaluator.authenticate(policy, context)
        if (authenticateResult.succeeded) {
            if (let Some(authenticateResultFeature) <- context.features.get<IAuthenticateResultFeature>()) {
                authenticateResultFeature.result = authenticateResult
            } else {
                let authFeatures = AuthenticationFeatures(authenticateResult)
                context.features.set<IHttpAuthenticationFeature>(authFeatures)
                context.features.set<IAuthenticateResultFeature>(authFeatures)
            }
        }
        return authenticateResult
    }
}
