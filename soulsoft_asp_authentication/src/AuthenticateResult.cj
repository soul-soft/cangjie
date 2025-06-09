package soulsoft_asp_authentication

import soulsoft_security_claims.*

public class AuthenticateResult {
    private var _none: Bool = false
    private var _failure: ?Exception = None
    private var _ticket: ?AuthenticationTicket = None
    private var _properties: ?AuthenticationProperties = None

    public static func createInstance(instance :(AuthenticateResult) -> Unit) {
        let result = AuthenticateResult()
        instance(result)
        return result
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
        return createInstance{ instance =>
            instance._failure = failure
        }
    }

    public static func fail(failure: Exception, properties: AuthenticationProperties) {
        return createInstance{ instance =>
            instance._failure = failure
            instance._properties = properties
        }
    }

    public static func success(ticket: AuthenticationTicket) {
         return createInstance{ instance =>
            instance._ticket = ticket
            instance._properties = ticket.properties
        }
    }

    public static func noResult() {
        return createInstance{ instance =>
            instance._none = true
        }
    }
}
