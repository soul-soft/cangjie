package aspire_identity_tokens

import aspire_identity_claims.*

public class TokenValidationResult {
    private TokenValidationResult(
        public let subject!: ClaimsPrincipal,
        public let securityToken!: ?SecurityToken = None,
        public let exception!: ?Exception = None) {
    }

    public static func success(subject: ClaimsPrincipal, securityToken: SecurityToken) {
        TokenValidationResult(subject: subject, securityToken: securityToken)
    }

    public static func failed(exception: Exception) {
        TokenValidationResult(subject: ClaimsPrincipal(), exception: exception)
    }

    public prop isValid: Bool {
        get() {
            exception.isNone()
        }
    }
}
