package aspire_web_authentication

import aspire_identity_claims.*

public interface IHttpAuthenticationFeature {
    prop user: ?ClaimsPrincipal
}
