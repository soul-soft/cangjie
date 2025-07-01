package soulsoft_identity_tokens_jwt

import std.time.*
import std.convert.*
import std.collection.*
import stdx.encoding.json.*
import soulsoft_identity_claims.*
import soulsoft_identity_tokens.*

public class JwtSecurityTokenHandler <: SecurityTokenHandler {
    public func writeToken(token: JwtSecurityToken) {
        let headerBase64Url = token.header.toBase64UrlString()
        let payloadBase64Url = token.payload.toBase64UrlString()
        let text = "${headerBase64Url}.${payloadBase64Url}"
        let provider = getSignatureProvider(token.header.signingCredentials)
        let sign = Base64UrlEncoder.encode(provider.sign(text.toArray()))
        return "${text}.${sign}"
    }

    public func validateToken(token: String, parameters: TokenValidationParameters): TokenValidationResult {
        try {
            let segments = token.split('.')

            if (segments.size != 3) {
                throw SecurityTokenValidationException("")
            }   

            let headerJson = Base64UrlEncoder.decode(segments[0]).flatMap {f => String.fromUtf8(f)}.getOrThrow {
                SecurityTokenValidationException("")
            }

            let claims = JwtJsonSerializer.deserialize(headerJson)
            let algorithm = (claims["alg"] as String).getOrThrow {
                SecurityTokenValidationException("")
            }
            
            let signData = Base64UrlEncoder.decode(segments[2]).getOrThrow{
                SecurityTokenValidationException("")
            }

            let issuerSigningKeys = ArrayList<SecurityKey>(parameters.issuerSigningKeys)

            if (let Some(issuerSigningKey) <- parameters.issuerSigningKey) {
                issuerSigningKeys.add(issuerSigningKey)
            }

            if (issuerSigningKeys.size == 0) {
                throw SecurityTokenValidationException("")
            }

            let signingCredentials = validateSignature("${segments[0]}.${segments[1]}", signData, algorithm, issuerSigningKeys).getOrThrow{
                SecurityTokenValidationException("")
            }

            let jwtHeader = JwtHeader(signingCredentials, claims)
            let payloadJson = Base64UrlEncoder.decode(segments[1]).flatMap {f => String.fromUtf8(f)}.getOrThrow {
                SecurityTokenValidationException("")
            }
            
            let jwtPayload = JwtPayload(JwtJsonSerializer.deserialize(payloadJson))
            let securityToken = JwtSecurityToken(jwtHeader, jwtPayload)
            let identity = ClaimsIdentity(parameters.authenticationType)
            identity.addClaims(securityToken.payload.toClaims())
            let subject = ClaimsPrincipal(identity)
            validateSubject(subject, parameters)
            return TokenValidationResult.success(subject, securityToken)
        }catch (exception: Exception) {
            return TokenValidationResult.failed(exception)
        }
    }

    private func validateSignature(text: String, signData: Array<Byte>, algorithm: String, signingKeys: Collection<SecurityKey>): ?SigningCredentials{
        for (signingKey in signingKeys) {
            let signingCredentials = SigningCredentials(signingKey, algorithm)
            let provider = getSignatureProvider(signingCredentials)
            if (provider.verify(text.toArray(), signData)) {
                return signingCredentials
            }
        }
        return None
    }

    private func validateSubject(subject: ClaimsPrincipal, parameters: TokenValidationParameters) {
       
        if (parameters.requireExpirationTime) {
            if (let Some(notBefore) <- subject.findFirstValue(ClaimNames.NotBefore).flatMap{f => Int64.parse(f)}) {
                if (DateTime.now() < DateTime.fromUnixTimeStamp(Duration.second * notBefore)) {
                    throw SecurityTokenValidationException("NotBefore validation failed.")
                }
            }

            let expTimestamp = subject.findFirstValue(ClaimNames.ExpirationTime).flatMap{f => Int64.parse(f)}
            
            if (parameters.requireExpirationTime && expTimestamp.isNone()) {
                throw SecurityTokenValidationException("NotBefore validation failed.")
            }
           
            if (parameters.validateLifetime && let Some(expirationTime) <- expTimestamp) {
                if (DateTime.now() > DateTime.fromUnixTimeStamp(Duration.second * expirationTime)) {
                    throw SecurityTokenValidationException("ExpirationTime validation failed.")
                }
            }else {
                throw SecurityTokenValidationException("ExpirationTime validation failed")
            }
        }

        if (parameters.validateIssuer) {
            let issuers = parameters.validIssuers |> collectHashSet
            if (let Some(issuer) <- parameters.validIssuer) {
                issuers.add(issuer)
            }
            let claims = subject.findAll(ClaimNames.Issuer) |> map{f => f.value}
            if (!claims.any{f => issuers.contains(f)}) {
                throw SecurityTokenValidationException("Issuer validation failed. ")
            }
        }

        if (parameters.validateAudience) {
            let audiences = parameters.validAudiences |> collectHashSet
            if (let Some(audience) <- parameters.validAudience) {
                audiences.add(audience)
            }
            let claims = subject.findAll(ClaimNames.Audience) |> map{f => f.value}
            if (!claims.any{f => audiences.contains(f)}) {
                throw SecurityTokenValidationException("Audience validation failed. ")
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
