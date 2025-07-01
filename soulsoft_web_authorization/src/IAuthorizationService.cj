package soulsoft_web_authorization

import soulsoft_identity_claims.*

public interface IAuthorizationService {
    func authorize(user: ClaimsPrincipal, resource: ?Object, policyName: String): AuthorizationResult
   
    func authorize(user: ClaimsPrincipal, resource: ?Object, requirements: Collection<IAuthorizationRequirement>): AuthorizationResult

    func authorize(user: ClaimsPrincipal, resource: ?Object, policy: AuthorizationPolicy): AuthorizationResult {
        this.authorize(user, resource, policy.requirements)
    }

    func authorize(user: ClaimsPrincipal, policy: AuthorizationPolicy): AuthorizationResult {
        this.authorize(user, None, policy)
    }

    func authorize(user: ClaimsPrincipal, policyName: String): AuthorizationResult {
        this.authorize(user, None, policyName)
    }
}
