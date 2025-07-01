package soulsoft_web_authentication

import soulsoft_security_claims.*

public class AuthenticateResult {

    AuthenticateResult(
        public let none!: Bool = false, 
        public let ticket!: ?AuthenticationTicket = None, 
        public let properties!: ?AuthenticationProperties = None,
        public let failure!: ?Exception = None) {
    }

    public prop succeeded: Bool {
        get() {
            !ticket.isNone()
        }
    }

    public prop principal: ?ClaimsPrincipal {
        get() {
            ticket.flatMap{f => f.principal}
        }
    }

    public static func fail(failure: Exception) {
        return AuthenticateResult(failure: failure)
    }

    public static func fail(failure: Exception, properties: AuthenticationProperties) {
        return AuthenticateResult(failure: failure, properties : properties)
    }

    public static func success(ticket: AuthenticationTicket) {
         return AuthenticateResult(ticket: ticket, properties: ticket.properties)
    }

    public static func noResult() {
        return AuthenticateResult(none: true)
    }
}
