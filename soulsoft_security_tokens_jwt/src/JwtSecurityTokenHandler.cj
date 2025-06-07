package soulsoft_security_tokens_jwt

import std.time.*
import std.convert.*
import std.collection.*
import stdx.encoding.json.*
import soulsoft_security_claims.*

public class JwtSecurityTokenHandler {
    public func writeToken(token: JwtSecurityToken) {
        let headerBase64Url = token.header.toBase64UrlString()
        let payloadBase64Url = token.payload.toBase64UrlString()
        let text = "${headerBase64Url}.${payloadBase64Url}"
        let provider = getSignatureProvider(token.header.signingCredentials)
        let sign = Base64UrlEncoder.encode(provider.sign(text.toArray()))
        return "${text}.${sign}"
    }

    public func validateToken(token: String, parameters: TokenValidationParameters): ClaimsPrincipal {
        let securityToken = validateSign(token, parameters.issuerSigningKey.getOrThrow())       
        let identity = ClaimsIdentity(parameters.authenticationType)
        identity.addClaims(securityToken.payload.toClaims())
        let subject = ClaimsPrincipal(identity)
        validateSubject(subject, parameters)
        return subject
    }


    private func validateSign(token: String, signingKey: SecurityKey): JwtSecurityToken {
        let segments = token.split('.')

        if (segments.size != 3) {
            throw SecurityTokenValidationException(
                "IDX10508: Signature validation failed. Signature is improperly formatted.")
        }

        let headerJson = Base64UrlEncoder.decode(segments[0]).flatMap {f => String.fromUtf8(f)}.getOrThrow {
            SecurityTokenValidationException("IDX10508: Signature validation failed. Signature is improperly formatted.")
        }

        let claims = JsonUtilities.toHashMap(headerJson)
        let algorithm = (claims["alg"] as String).getOrThrow {
            SecurityTokenValidationException("IDX10508: Signature validation failed. Signature is improperly formatted.")
        }

        let signingCredentials = SigningCredentials(signingKey, algorithm)
        let provider = getSignatureProvider(signingCredentials)
        let text = "${segments[0]}.${segments[1]}"
        let sign = Base64UrlEncoder.decode(segments[2]).getOrThrow {
            SecurityTokenValidationException("IDX10508: Signature validation failed. Signature is improperly formatted.")
        }
        if (!provider.verify(text.toArray(), sign)) {
            throw SecurityTokenValidationException("JWT signature validation failed")
        }
        let jwtHeader = JwtHeader(signingCredentials, claims)
        let payloadJson = Base64UrlEncoder.decode(segments[1]).flatMap {f => String.fromUtf8(f)}.getOrThrow {
            SecurityTokenValidationException("Failed to decode or parse JWT payload")
        }
        
        let payloadClaims = JsonUtilities.toHashMap(payloadJson)
       
        let jwtPayload = JwtPayload(payloadClaims)
        return JwtSecurityToken(jwtHeader, jwtPayload)
    }

    private func validateSubject(subject: ClaimsPrincipal, parameters: TokenValidationParameters) {
        if (parameters.requireExpirationTime) {
            if (let Some(expirationTime) <- subject.findFirstValue(ClaimNames.ExpirationTime).flatMap{f => Int64.parse(f)}) {
                if (DateTime.now() > DateTime.fromUnixTimeStamp(Duration.second * expirationTime)) {
                    throw SecurityTokenValidationException("IDX10225: Lifetime validation failed.")
                }
            }else {
                throw SecurityTokenValidationException("IDX10225: Lifetime validation failed")
            }
        }
        if (parameters.validateIssuer) {
            let issuers = parameters.validIssuers |> collectHashSet
            if (let Some(issuer) <- parameters.validIssuer) {
                issuers.add(issuer)
            }
            let claims = subject.findAll(ClaimNames.Issuer) |> map{f => f.value}
            if (!claims.any{f => issuers.contains(f)}) {
                throw SecurityTokenValidationException("IDX10225: Audience validation failed. ")
            }
        }
        if (parameters.validateAudience) {
            let issuers = parameters.validAudiences |> collectHashSet
            if (let Some(audience) <- parameters.validAudience) {
                issuers.add(audience)
            }
            let claims = subject.findAll(ClaimNames.Audience) |> map{f => f.value}
            if (!claims.any{f => issuers.contains(f)}) {
                throw SecurityTokenValidationException("IDX10225: Audience validation failed. ")
            }
        }
    }

    private static func getSignatureProvider(credentials: SigningCredentials) {
        if (credentials.key is AsymmetricSecurityKey) {
            return AsymmetricSignatureProvider(credentials.key, credentials.algorithm)
        }
        return SymmetricSignatureProvider(credentials.key, credentials.algorithm)
    }
}
