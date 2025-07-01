package soulsoft_web_authentication

import soulsoft_security_claims.*

public class AuthenticationTicket {
    private let _principal: ClaimsPrincipal
    private let _authenticationScheme: String
    private let _properties: AuthenticationProperties

    public init(principal: ClaimsPrincipal, authenticationScheme: String) {
        this(principal, authenticationScheme, None)
    }

    public init(principal: ClaimsPrincipal, authenticationScheme: String, properties: ?AuthenticationProperties) {
        _principal = principal
        _properties = properties ?? AuthenticationProperties()
        _authenticationScheme = authenticationScheme
    }

    public prop authenticationScheme: String {
        get() {
            _authenticationScheme
        }
    }

    public prop principal: ClaimsPrincipal {
        get() {
            _principal
        }
    }

    public prop properties: AuthenticationProperties {
        get() {
            _properties
        }
    }
}
