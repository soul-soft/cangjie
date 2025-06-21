package soulsoft_identity_tokens_jwt

import std.time.*
import std.convert.*
import std.collection.*
import stdx.encoding.json.*
import soulsoft_security_claims.*

public class JwtPayload <: JwtContent {
    public init(all: Collection<(String, Any)>) {
        add(all: all)
    }

    public init(issuer!: ?String = None, audience!: ?String = None, notBefore!: ?DateTime = None,
        expires!: ?DateTime = None, issuedAt!: ?DateTime = None, claims!: Array<(String, Any)>) {
        add(all: claims)
        addFirstPriorityClaims(issuer, audience, notBefore, expires, issuedAt)
    }

    public func addClaim(claim: Claim) {
        if (claim.valueType == ClaimValueTypes.Integer) {
            add(claim.name, Int64.parse(claim.value))
        } else if (claim.valueType == ClaimValueTypes.Boolean) {
            add(claim.name, Bool.parse(claim.value))
        } else if (claim.valueType == ClaimValueTypes.Date) {
            add(claim.name, DateTime.parse(claim.value, "yyyy-MM-dd HH:mm:ss"))
        } else if (claim.valueType == ClaimValueTypes.DateTime) {
            add(claim.name, DateTime.parse(claim.value))
        } else {
            add(claim.name, claim.value)
        }
    }

    public func addClaims(claims: Collection<Claim>) {
        for (pattern in claims) {
            addClaim(pattern)
        }
    }

    private func addFirstPriorityClaims(issuer: ?String, audience: ?String, notBefore: ?DateTime, expires: ?DateTime,
        issuedAt: ?DateTime) {
        if (let Some(issuer) <- issuer) {
            add(ClaimNames.Issuer, issuer)
        }
        if (let Some(audience) <- audience) {
            add(ClaimNames.Audience, audience)
        }
        if (let Some(notBefore) <- notBefore) {
            add(ClaimNames.NotBefore, notBefore.toUnixTimeStamp().toSeconds())
        }
        if (let Some(expires) <- expires) {
            add(ClaimNames.ExpirationTime, expires.toUnixTimeStamp().toSeconds())
        }
        if (let Some(issuedAt) <- issuedAt) {
            add(ClaimNames.IssuedAt, issuedAt.toUnixTimeStamp().toSeconds())
        }
    }
}
