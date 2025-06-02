package soulsoft_security_jwt

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
        let splits = token.split('.')

        if (splits.size != 3) {
            throw SecurityTokenValidationException(
                "Token format is invalid: JWT must have exactly 3 parts separated by '.'")
        }
        let text = "${splits[0]}.${splits[1]}"
        let sign = Base64UrlEncoder
            .decode(splits[2])
            .getOrThrow {
                SecurityTokenValidationException("Failed to decode JWT signature (third segment)")
            }
        let headerJson = Base64UrlEncoder
            .decode(splits[0])
            .flatMap {f => String.fromUtf8(f)}
            .getOrThrow {
                SecurityTokenValidationException("Failed to decode or parse JWT header")
            }
        let headers = JsonConverter().toHashMap(headerJson)
        let algorithm = (headers["alg"] as String).getOrThrow {
            SecurityTokenValidationException("JWT header missing 'alg' field")
        }
        let jwtHeader = JwtHeader(SigningCredentials(parameters.issuerSigningKey, algorithm))
        jwtHeader.add(all: headers)
        let payloadJson = Base64UrlEncoder
            .decode(splits[1])
            .flatMap {f => String.fromUtf8(f)}
            .getOrThrow {
                SecurityTokenValidationException("Failed to decode or parse JWT payload")
            }
        let jwtPayload = JwtPayload(payloadJson)
        let jwtSecurityToken = JwtSecurityToken(jwtHeader, jwtPayload)
        let provider = getSignatureProvider(jwtHeader.signingCredentials)
        if (!provider.verify(text.toArray(), sign)) {
            throw SecurityTokenValidationException("JWT signature validation failed")
        }
        let identity = ClaimsIdentity(parameters.authenticationType)
        identity.addClaims(jwtSecurityToken.payload.claims())
        let subject = ClaimsPrincipal(identity)
        return subject
    }

    private static func getSignatureProvider(credentials: SigningCredentials) {
        if (credentials.key is AsymmetricSecurityKey) {
            return AsymmetricSignatureProvider(credentials.key, credentials.algorithm)
        }
        return SymmetricSignatureProvider(credentials.key, credentials.algorithm)
    }
}
