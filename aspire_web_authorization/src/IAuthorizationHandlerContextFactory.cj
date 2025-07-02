package aspire_web_authorization

import aspire_identity_claims.*

public interface IAuthorizationHandlerContextFactory {
    func createContext(requirements: Collection<IAuthorizationRequirement>, user: ClaimsPrincipal, resource: ?Object): AuthorizationHandlerContext
}
