package soulsoft_security_jwt

public class JwtSecurityTokenHandler {
    public func writeToken(token: JwtSecurityToken)  {
        let headerBase64Url = token.header.toJson().toJsonString() |> toBase64UrlString
        let payloadBase64Url = token.payload.toJson().toJsonString() |> toBase64UrlString
        let text = "${headerBase64Url}.${payloadBase64Url}"
        let key = token.header.signingCredentials.key
        let algorithm = token.header.signingCredentials.algorithm
        let provider = SymmetricSignatureProvider(key, algorithm)
        let sign = provider.sign(text.toArray()) |> toBase64UrlString
        return "${text}.${sign}"
    }
}