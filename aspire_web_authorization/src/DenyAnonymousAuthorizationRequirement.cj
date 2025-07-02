package aspire_web_authorization

import std.collection.*

public class DenyAnonymousAuthorizationRequirement 
    <: AuthorizationHandler<DenyAnonymousAuthorizationRequirement> & IAuthorizationRequirement {
    protected func handleRequirement(context: AuthorizationHandlerContext,
        requirement: DenyAnonymousAuthorizationRequirement) {
        var user = context.user
        var isAuthenticated = user.identies |> any {i => i.isAuthenticated}
        if (isAuthenticated) {
            context.succeed(requirement);
        }
    }

    public func toString() {
        "DenyAnonymousAuthorizationRequirement: Requires an authenticated user."
    }
}
