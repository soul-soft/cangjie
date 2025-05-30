package soulsoft_asp_authorization

public interface IAuthorizationHandlerProvider {
    func getHandlers(context: AuthorizationHandlerContext): Collection<IAuthorizationHandler>
}
