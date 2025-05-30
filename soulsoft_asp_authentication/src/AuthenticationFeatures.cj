package soulsoft_asp_authentication

import soulsoft_security_claims.*

class AuthenticationFeatures <: IAuthenticateResultFeature & IHttpAuthenticationFeature {
    private let _result: AuthenticateResult

    init(result: AuthenticateResult) {
        _result = result
    }

    public prop result: AuthenticateResult {
        get() {
            _result
        }
    }

    public prop user: ?ClaimsPrincipal {
        get() {
            _result.principal
        }
    }
}
