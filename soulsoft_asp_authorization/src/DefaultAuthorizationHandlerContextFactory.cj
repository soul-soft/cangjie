package soulsoft_asp_authorization

import soulsoft_security_claims.*

public class DefaultAuthorizationHandlerContextFactory <: IAuthorizationHandlerContextFactory {

    public func createContext(requirements: Collection<IAuthorizationRequirement>, user: ClaimsPrincipal,
        resource: ?Object){
        return AuthorizationHandlerContext(requirements, user, resource)
    }
}
