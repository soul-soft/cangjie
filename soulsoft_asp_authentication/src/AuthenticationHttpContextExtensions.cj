package soulsoft_asp_authentication

import soulsoft_asp_http.*

public interface AuthenticationHttpContextExtension {
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
}

extend HttpContext <: AuthenticationHttpContextExtension {
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
}
