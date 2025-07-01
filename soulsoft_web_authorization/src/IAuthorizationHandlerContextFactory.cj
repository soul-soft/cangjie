package soulsoft_web_authorization

import soulsoft_identity_claims.*

public interface IAuthorizationHandlerContextFactory {
    func createContext(requirements: Collection<IAuthorizationRequirement>, user: ClaimsPrincipal, resource: ?Object): AuthorizationHandlerContext
}
