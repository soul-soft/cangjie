package soulsoft_web_authorization

import soulsoft_security_claims.*

public interface IAuthorizationHandlerContextFactory {
    func createContext(requirements: Collection<IAuthorizationRequirement>, user: ClaimsPrincipal, resource: ?Object): AuthorizationHandlerContext
}
