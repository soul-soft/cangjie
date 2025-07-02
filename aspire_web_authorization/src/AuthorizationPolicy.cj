package aspire_web_authorization

import std.unicode.*
import std.collection.*
import aspire_web_http.*

public class AuthorizationPolicy {
    private let _requirements = ArrayList<IAuthorizationRequirement>()
    private let _authenticationSchemes = ArrayList<String>()

    public init(requirements: Collection<IAuthorizationRequirement>, authenticationSchemes: Collection<String>) {
        _requirements.add(all: requirements)
        _authenticationSchemes.add(all: authenticationSchemes)
    }

    public prop requirements: ReadOnlyList<IAuthorizationRequirement> {
        get() {
            _requirements
        }
    }

    public prop authenticationSchemes: ReadOnlyList<String> {
        get() {
            _authenticationSchemes
        }
    }

    public static func combine(policies: Array<AuthorizationPolicy>) {
        let builder = AuthorizationPolicyBuilder()
        for (pattern in policies) {
            builder.combine(pattern)
        }
        return builder.build()
    }

    public static func combine(policyProvider: IAuthorizationPolicyProvider, authorizeData: Collection<IAuthorizeData>,
        policies: Collection<AuthorizationPolicy>) {
        var policyBuilder: ?AuthorizationPolicyBuilder = None
        let anyPolicies = policies.size > 0
        for (pattern in authorizeData) {
            policyBuilder = policyBuilder ?? AuthorizationPolicyBuilder()
            var useDefaultPolicy = !anyPolicies
            if (let Some(policyName) <- pattern.policy && !policyName.isEmpty()) {
                if (let Some(policy) <- policyProvider.getPolicy(policyName)) {
                    policyBuilder.flatMap {f => f.combine(policy)}
                    useDefaultPolicy = false
                } else {
                    throw UnsupportedException("not found policy:${policyName}")
                }
            }

            let authTypes = pattern
                .authenticationSchemes
                .flatMap {
                    f => f.split(',', removeEmpty: true) |> filter {f => !f.isEmpty()} |> map {f => f.trim()} |>
                        collectArray
                }

            if (let Some(authTypes) <- authTypes) {
                for (pattern in authTypes) {
                    policyBuilder.flatMap {f => f.authenticationSchemes.add(pattern)}
                }
            }

            if (useDefaultPolicy) {
                if (let Some(policy) <- policyProvider.getDefaultPolicy()) {
                    policyBuilder.flatMap {f => f.combine(policy)}
                }
            }
        }
        if (anyPolicies) {
            policyBuilder = policyBuilder ?? AuthorizationPolicyBuilder()
            for (pattern in policies) {
                policyBuilder.flatMap {f => f.combine(pattern)}
            }
        }

        if (policyBuilder.isNone()) {
            if (let Some(fallbackPolicy) <- policyProvider.getFallbackPolicy()) {
                return fallbackPolicy
            }
        }
        return policyBuilder?.build()
    }
}
