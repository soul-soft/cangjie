package soulsoft_asp_authentication

import soulsoft_security_claims.*

public class AuthenticateResult {
    private let _none: Bool
    private let _failure: ?Exception
    private let _ticket: ?AuthenticationTicket
    private let _properties: ?AuthenticationProperties

    public init(ticket!: ?AuthenticationTicket = None, failure!: ?Exception = None,
        properties!: ?AuthenticationProperties = None, none!: Bool = false) {
        _ticket = ticket
        _failure = failure
        _properties = properties
        _none = none
    }

    public prop none: Bool {
        get() {
            _none
        }
    }

    public prop failure: ?Exception {
        get() {
            _failure
        }
    }

    public prop succeeded: Bool {
        get() {
            !_ticket.isNone()
        }
    }

    public prop ticket: ?AuthenticationTicket {
        get() {
            _ticket
        }
    }

    public prop principal: ?ClaimsPrincipal {
        get() {
            _ticket?.principal
        }
    }

    public prop properties: ?AuthenticationProperties {
        get() {
            _properties
        }
    }

    public static func fail(failure: Exception) {
        return AuthenticateResult(failure: failure)
    }

    public static func fail(failure: Exception, properties: AuthenticationProperties) {
        return AuthenticateResult(failure: failure, properties: properties)
    }

    public static func success(ticket: AuthenticationTicket) {
        return AuthenticateResult(ticket: ticket)
    }

    public static func noResult() {
        return AuthenticateResult(none: true)
    }
}
