package aspire_web_authorization

public interface IAuthorizationHandlerProvider {
    func getHandlers(context: AuthorizationHandlerContext): Collection<IAuthorizationHandler>
}
