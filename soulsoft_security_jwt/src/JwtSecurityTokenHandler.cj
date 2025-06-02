package soulsoft_security_jwt

public class JwtSecurityTokenHandler {
    public func writeToken(token: JwtSecurityToken) {
        let headerBase64Url = token.header.toBase64UrlString()
        let payloadBase64Url = token.payload.toBase64UrlString()
        let text = "${headerBase64Url}.${payloadBase64Url}"
        let provider = getSignatureProvider(token.header.signingCredentials)
        let sign = Base64UrlEncoder.encode(provider.sign(text.toArray()))
        return "${text}.${sign}"
    }

    private static func getSignatureProvider(credentials: SigningCredentials) {
        if (credentials.key is AsymmetricSecurityKey) {
            return AsymmetricSignatureProvider(credentials.key, credentials.algorithm)
        }
        return SymmetricSignatureProvider(credentials.key, credentials.algorithm)
    }
}
