package soulsoft_asp_authentication

import soulsoft_security_claims.*

public class AuthenticationFeatures <: IAuthenticateResultFeature & IHttpAuthenticationFeature {
    private var _result: AuthenticateResult

    public init(result: AuthenticateResult) {
        _result = result
    }

    public mut prop result: AuthenticateResult {
        get() {
            _result
        }
        set(value) {
            _result = value
        }
    }

    public prop user: ?ClaimsPrincipal {
        get() {
            _result.principal
        }
    }
}
