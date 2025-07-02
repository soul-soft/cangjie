package aspire_web_authorization

public interface IAuthorizationHandler {
    func handle(context: AuthorizationHandlerContext): Unit
}
