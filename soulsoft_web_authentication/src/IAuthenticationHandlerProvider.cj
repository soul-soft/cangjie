package soulsoft_web_authentication

import soulsoft_web_http.*
import soulsoft_extensions_injection.*

public interface IAuthenticationHandlerProvider {
    func getHandler(context: HttpContext, schemeName: String): ?IAuthenticationHandler
}

class AuthenticationHandlerProvider <: IAuthenticationHandlerProvider {
    private let _schemes: IAuthenticationSchemeProvider

    public AuthenticationHandlerProvider(schemes: IAuthenticationSchemeProvider) {
        _schemes = schemes
    }

    public func getHandler(context: HttpContext, schemeName: String): ?IAuthenticationHandler {
        if (let Some(scheme) <- _schemes.getScheme(schemeName)) {
            if (let handler: IAuthenticationHandler <- context.services.getOrThrow(scheme.handlerType)) {
                handler.initialize(scheme, context)
                return handler
            }
        }
        return None
    }
}
