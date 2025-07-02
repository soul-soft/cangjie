package aspire_web_authorization

import aspire_web_http.*

public interface AuthorizationAppBuilderExtensions {
    func useAuthorization(): ApplicationBuilder
}

extend ApplicationBuilder <: AuthorizationAppBuilderExtensions {
    public func useAuthorization(): ApplicationBuilder {
        this.use<AuthorizationMiddleware>()
        return this
    }
}
