package soulsoft_web_authorization

public interface IAuthorizationPolicyProvider {
    func getPolicy(policyName: String): ?AuthorizationPolicy
    func getDefaultPolicy(): ?AuthorizationPolicy
    func getFallbackPolicy(): ?AuthorizationPolicy
}
