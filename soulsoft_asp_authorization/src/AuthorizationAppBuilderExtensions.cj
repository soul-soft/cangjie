package soulsoft_asp_authorization

import soulsoft_asp_http.*

public interface AuthorizationAppBuilderExtensions {
    func useAuthorization(): ApplicationBuilder
}

extend ApplicationBuilder <: AuthorizationAppBuilderExtensions {
    public func useAuthorization(): ApplicationBuilder {
        this.use<AuthorizationMiddleware>()
        return this
    }
}
