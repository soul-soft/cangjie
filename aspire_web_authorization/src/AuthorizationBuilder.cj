package aspire_web_authorization

import aspire_extensions_options.*
import aspire_extensions_injection.*

public class AuthorizationBuilder {
    private let _services: ServiceCollection

    public init(services: ServiceCollection) {
        _services = services
    }

    public prop services: ServiceCollection {
        get() {
            _services
        }
    }

    public func setInvokeHandlersAfterFailure(invoke: Bool) {
        _services.configure<AuthorizationOptions> {o => o.invokeHandlersAfterFailure = invoke}
        return this
    }

    public func setDefaultPolicy(policy: AuthorizationPolicy) {
        _services.configure<AuthorizationOptions> {o => o.defaultPolicy = policy}
        return this
    }

    public func setFallbackPolicy(policy: AuthorizationPolicy) {
        _services.configure<AuthorizationOptions> {o => o.fallbackPolicy = policy}
        return this
    }

    public func addPolicy(name: String, policy: AuthorizationPolicy) {
        _services.configure<AuthorizationOptions> {o => o.addPolicy(name, policy)}
        return this
    }

    public func addPolicy(name: String, configurePolicy: (AuthorizationPolicyBuilder) -> Unit) {
        _services.configure<AuthorizationOptions> {o => o.addPolicy(name, configurePolicy)}
        return this
    }

    public func addDefaultPolicy(name: String, policy: AuthorizationPolicy) {
        setDefaultPolicy(policy)
        return addPolicy(name, policy)
    }

    public func addDefaultPolicy(name: String, configure: (AuthorizationPolicyBuilder) -> Unit) {
        var policyBuilder = AuthorizationPolicyBuilder()
        configure(policyBuilder)
        return addDefaultPolicy(name, policyBuilder.build())
    }

    public func addFallbackPolicy(name: String, policy: AuthorizationPolicy) {
        setFallbackPolicy(policy)
        return addPolicy(name, policy)
    }

    public func addFallbackPolicy(name: String, configure: (AuthorizationPolicyBuilder) -> Unit) {
        var policyBuilder = AuthorizationPolicyBuilder()
        configure(policyBuilder)
        return addFallbackPolicy(name, policyBuilder.build())
    }
}
