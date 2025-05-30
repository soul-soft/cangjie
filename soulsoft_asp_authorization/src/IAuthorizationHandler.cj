package soulsoft_asp_authorization

public interface IAuthorizationHandler {
    func handle(context: AuthorizationHandlerContext): Unit
}
