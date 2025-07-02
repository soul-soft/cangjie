package aspire_web_authentication

import aspire_web_http.*

public interface AuthenticationApplicationBuilderExtension {
    func useAuthentication(): ApplicationBuilder
}

extend ApplicationBuilder <: AuthenticationApplicationBuilderExtension {
    public func useAuthentication() {
        this.use<AuthenticationMiddleware>()
        return this
    }
}
