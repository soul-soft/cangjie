package soulsoft_web_authorization

public class DefaultAuthorizationHandlerProvider <: IAuthorizationHandlerProvider {
    private let _handlers: Collection<IAuthorizationHandler>

    init(handlers: Collection<IAuthorizationHandler>) {
        _handlers = handlers
    }

    public func getHandlers(_: AuthorizationHandlerContext) {
        _handlers
    }
}
