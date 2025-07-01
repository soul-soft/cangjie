package soulsoft_web_authentication

import soulsoft_web_http.*

public interface AuthenticationHttpContextExtensions {
    func authenticate(): AuthenticateResult
    func authenticate(scheme: ?String): AuthenticateResult
    func challenge(): Unit
    func challenge(scheme: ?String): Unit
    func challenge(properties: ?AuthenticationProperties): Unit
    func challenge(scheme: ?String, properties: ?AuthenticationProperties): Unit
    func forbid(): Unit
    func forbid(scheme: ?String): Unit
    func forbid(properties: ?AuthenticationProperties): Unit
    func forbid(scheme: ?String, properties: ?AuthenticationProperties): Unit
    func getToken(tokenName: String): ?String
    func getToken(scheme: String, tokenName: String): ?String
}

extend HttpContext <: AuthenticationHttpContextExtensions {
    public func authenticate(): AuthenticateResult {
        authenticate(None)
    }

    public func authenticate(scheme: ?String): AuthenticateResult {
        getAuthenticationService().authenticate(this, scheme)
    }

    public func challenge() {
        challenge(None, None)
    }

    public func challenge(scheme: ?String) {
        challenge(scheme, None)
    }

    public func challenge(properties: ?AuthenticationProperties) {
        challenge(None, properties)
    }

    public func challenge(scheme: ?String, properties: ?AuthenticationProperties) {
        getAuthenticationService().challenge(this, scheme, properties)
    }

    public func forbid() {
        forbid(None, None)
    }

    public func forbid(scheme: ?String) {
        forbid(scheme, None)
    }

    public func forbid(properties: ?AuthenticationProperties) {
        forbid(None, properties)
    }

    public func forbid(scheme: ?String, properties: ?AuthenticationProperties) {
        getAuthenticationService().forbid(this, scheme, properties)
    }

    private func getAuthenticationService() {
        return services.getOrThrow<IAuthenticationService>()
    }

    public func getToken(tokenName: String): ?String {
        authenticate().properties.flatMap{f => f.getTokenValue(tokenName)}
    }

    public func getToken(scheme: String, tokenName: String): ?String {
        authenticate(scheme).properties.flatMap{f => f.getTokenValue(tokenName)}
    }
}
