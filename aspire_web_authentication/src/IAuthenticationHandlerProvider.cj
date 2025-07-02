package aspire_web_authentication

import aspire_web_http.*
import aspire_extensions_injection.*

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
