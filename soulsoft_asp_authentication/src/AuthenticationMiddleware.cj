package soulsoft_asp_authentication

import soulsoft_asp_http.*

public class AuthenticationMiddleware <: IMiddleware {
    private let _schemes: IAuthenticationSchemeProvider
    private let _handlers: IAuthenticationHandlerProvider

    public init(schemes: IAuthenticationSchemeProvider, handlers: IAuthenticationHandlerProvider) {
        _schemes = schemes
        _handlers = handlers
    }

    public func invoke(context: HttpContext, next: () -> Unit): Unit {
        if (let Some(defaultAuthenticate) <- _schemes.getDefaultAuthenticateScheme()) {
             let result = context.authenticate(defaultAuthenticate.name)
            if (let Some(user) <- result.principal) {
                context.user = user
            }
            if (result.succeeded) {
                let features = AuthenticationFeatures(result)
                context.features.set<IHttpAuthenticationFeature>(features)
                context.features.set<IAuthenticateResultFeature>(features)
            }
        }
        next()
    }
}
