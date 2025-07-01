package soulsoft_web_authentication

import soulsoft_identity_claims.*

public interface IHttpAuthenticationFeature {
    prop user: ?ClaimsPrincipal
}
