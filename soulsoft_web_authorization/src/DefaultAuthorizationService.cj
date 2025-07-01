package soulsoft_web_authorization

import soulsoft_identity_claims.*
import soulsoft_extensions_options.*


public class DefaultAuthorizationService <: IAuthorizationService {
    private let _options: AuthorizationOptions
    private let _handlers: IAuthorizationHandlerProvider
    private let _evaluator: IAuthorizationEvaluator
    private let _policyProvider: IAuthorizationPolicyProvider
    private let _contextFactory: IAuthorizationHandlerContextFactory

    public init(
        policyProvider: IAuthorizationPolicyProvider,
        handlers: IAuthorizationHandlerProvider,
        contextFactory: IAuthorizationHandlerContextFactory,
        evaluator: IAuthorizationEvaluator,
        options: IOptions<AuthorizationOptions>
    ) {
        _handlers = handlers
        _evaluator = evaluator
        _options = options.value
        _contextFactory = contextFactory
        _policyProvider = policyProvider
    }

    public func authorize(user: ClaimsPrincipal, resource: ?Object, policyName: String): AuthorizationResult {
        this.authorize(user, resource, _policyProvider.getPolicy(policyName).getOrThrow())
    }

    public func authorize(user: ClaimsPrincipal, resource: ?Object, requirements: Collection<IAuthorizationRequirement>): AuthorizationResult {
        let context = _contextFactory.createContext(requirements, user, resource)
        let handlers = _handlers.getHandlers(context)
        for (pattern in handlers) {
            pattern.handle(context)
            if (!_options.invokeHandlersAfterFailure && context.hasFailed) {
                break
            }
        }

        return _evaluator.evaluate(context)
    }
}
