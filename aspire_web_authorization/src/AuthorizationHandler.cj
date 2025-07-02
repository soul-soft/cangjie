package aspire_web_authorization

import std.collection.*

public abstract class AuthorizationHandler<TRequirement> <: IAuthorizationHandler where TRequirement <: IAuthorizationRequirement {
    public func handle(context: AuthorizationHandlerContext): Unit {
        for (pattern in context.requirements |> filterMap {f => f as TRequirement}) {
            handleRequirement(context, pattern)
        }
    }

    protected func handleRequirement(context: AuthorizationHandlerContext, requirement: TRequirement): Unit
}

public abstract class AuthorizationResourceHandler<TRequirement, TResource> <: IAuthorizationHandler where TRequirement <: IAuthorizationRequirement {
    public func handle(context: AuthorizationHandlerContext): Unit {
        if (let resource: TResource <- context.resource) {
            for (pattern in context.requirements |> filterMap {f => f as TRequirement}) {
                handleRequirement(context, pattern, resource)
            }
        }
    }

    protected func handleRequirement(context: AuthorizationHandlerContext, requirement: TRequirement,
        resource: TResource): Unit
}
