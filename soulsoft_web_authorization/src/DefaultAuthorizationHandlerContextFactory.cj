package soulsoft_web_authorization

import soulsoft_identity_claims.*

public class DefaultAuthorizationHandlerContextFactory <: IAuthorizationHandlerContextFactory {

    public func createContext(requirements: Collection<IAuthorizationRequirement>, user: ClaimsPrincipal,
        resource: ?Object){
        return AuthorizationHandlerContext(requirements, user, resource)
    }
}
