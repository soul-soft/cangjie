package soulsoft_security_jwt

public class TokenValidationParameters {
    public let issuerSigningKey: SecurityKey
    
    public init(issuerSigningKey: SecurityKey) {
        this.issuerSigningKey = issuerSigningKey
    }
    
    public var authenticationType: String = "AuthenticationTypes.Federation"
}
