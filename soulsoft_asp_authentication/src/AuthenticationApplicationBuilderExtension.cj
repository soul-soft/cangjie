package soulsoft_asp_authentication

import soulsoft_asp_http.*

public interface AuthenticationApplicationBuilderExtension {
    func useAuthentication(): ApplicationBuilder
}

extend ApplicationBuilder <: AuthenticationApplicationBuilderExtension {
    public func useAuthentication() {
        this.use<AuthenticationMiddleware>()
        return this
    }
}
