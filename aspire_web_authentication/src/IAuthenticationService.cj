package aspire_web_authentication

import aspire_web_http.*
import aspire_extensions_options.*

public interface IAuthenticationService {
    func authenticate(context: HttpContext, scheme: ?String): AuthenticateResult
    func challenge(context: HttpContext, scheme: ?String, properties: ?AuthenticationProperties): Unit
    func forbid(context: HttpContext, scheme: ?String, properties: ?AuthenticationProperties): Unit
}

class AuthenticationService <: IAuthenticationService {
    private let _schemes: IAuthenticationSchemeProvider
    private let _handlers: IAuthenticationHandlerProvider
    private let _options: AuthenticationOptions

    public init(schemes: IAuthenticationSchemeProvider, handlers: IAuthenticationHandlerProvider,
        options: IOptions<AuthenticationOptions>) {
        _schemes = schemes
        _handlers = handlers
        _options = options.value
    }

    public func authenticate(context: HttpContext, scheme: ?String): AuthenticateResult {
        let authenticateScheme = if (scheme.isNone()) {
            _schemes.getDefaultAuthenticateScheme().flatMap {f => f.name}
        } else {
            scheme
        }
        if (let Some(scheme) <- authenticateScheme) {
            let handler = _handlers.getHandler(context, scheme) ?? throw NoneValueException("authenticate scheme: ${scheme}")
            return handler.authenticate()
        }
        return AuthenticateResult.noResult()
    }
    public func challenge(context: HttpContext, scheme: ?String, properties: ?AuthenticationProperties) {
        let challengeScheme = if (scheme.isNone()) {
            _schemes.getDefaultChallengeScheme().flatMap {f => f.name}
        } else {
            scheme
        }
        if (let Some(scheme) <- challengeScheme) {
            let handler = _handlers.getHandler(context, scheme) ?? throw NoneValueException("challenge scheme: ${scheme}")
            handler.challenge(properties)
        }
    }
    public func forbid(context: HttpContext, scheme: ?String, properties: ?AuthenticationProperties) {
        let forbidScheme = if (scheme.isNone()) {
            _schemes.getDefaultForbidScheme().flatMap {f => f.name}
        } else {
            scheme
        }
        if (let Some(scheme) <- forbidScheme) {
            let handler = _handlers.getHandler(context, scheme) ?? throw NoneValueException("forbid scheme: ${scheme}")
            handler.forbid(properties)
        }
    }
}
