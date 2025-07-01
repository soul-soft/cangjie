package soulsoft_web_authentication

import soulsoft_security_claims.*

public interface IHttpAuthenticationFeature {
    prop user: ?ClaimsPrincipal
}
