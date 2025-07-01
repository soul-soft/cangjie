package soulsoft_web_authorization

import soulsoft_web_http.*

public interface AuthorizationAppBuilderExtensions {
    func useAuthorization(): ApplicationBuilder
}

extend ApplicationBuilder <: AuthorizationAppBuilderExtensions {
    public func useAuthorization(): ApplicationBuilder {
        this.use<AuthorizationMiddleware>()
        return this
    }
}
