package aspire_web_authorization

import std.collection.*

public class ClaimsAuthorizationRequirement <: AuthorizationHandler<ClaimsAuthorizationRequirement> & IAuthorizationRequirement {
    private let _claimName: String
    private let _emptyAllowedValues: Bool
    private let _allowedValues: Collection<String>

    public init(claimName: String, allowedValues: Array<String>) {
        _claimName = claimName
        _allowedValues = allowedValues
        _emptyAllowedValues = allowedValues.size == 0
    }

    public prop claimName: String {
        get() {
            _claimName
        }
    }

    public prop allowedValues: Collection<String> {
        get() {
            _allowedValues
        }
    }

    protected func handleRequirement(context: AuthorizationHandlerContext, requirement: ClaimsAuthorizationRequirement): Unit {
        var found = false
        if (requirement._emptyAllowedValues) {
            for (claim in context.user.claims) {
                if (requirement.claimName.equalsIgnoreAsciiCase(claim.name)) {
                    found = true
                    break
                }
            }
        } else {
            for (claim in context.user.claims) {
                if (requirement.claimName.equalsIgnoreAsciiCase(claim.name) && (requirement.allowedValues |>
                    any {a => a == claim.value})) {
                    found = true
                    break
                }
            }
        }
        if (found) {
            context.succeed(requirement)
        }
    }

    public func toString() {
        let value = String.join(_allowedValues |> collectArray, delimiter: '|')
        "ClaimsAuthorizationRequirement:claim.type=${_claimName}${value}"
    }
}
