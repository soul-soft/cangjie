package aspire_web_authorization

import std.collection.*
import aspire_identity_claims.*

class SecurityHelper {
    public static func mergeUserPrincipal(existingPrincipal: ?ClaimsPrincipal, additionalPrincipal: ?ClaimsPrincipal): ClaimsPrincipal {
        if (existingPrincipal.isNone() && let Some(additionalPrincipal) <- additionalPrincipal) {
            return additionalPrincipal
        }

        let newPrincipal = ClaimsPrincipal()
        if (let Some(additionalPrincipal) <- additionalPrincipal) {
            newPrincipal.addIdentity(additionalPrincipal.identies)
        }

        if (let Some(existingPrincipal) <- existingPrincipal) {
            let identities = existingPrincipal.identies |> filter {f => f.isAuthenticated || f.claims.size > 0} |>
                collectArray
            newPrincipal.addIdentity(identities)
        }
        return newPrincipal
    }
}
