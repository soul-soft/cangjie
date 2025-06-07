package soulsoft_security_tokens_jwt

public class TokenValidationParameters {
    public var issuerSigningKey: ?SecurityKey = None

    public init() {
        this.issuerSigningKey = None
    }

    public init(issuerSigningKey: SecurityKey) {
        this.issuerSigningKey = issuerSigningKey
    }
    public var validateIssuer = true
    public var validIssuer = Option<String>.None
    public var validIssuers = Array<String>()
    public var validateAudience = true
    public var validAudience = Option<String>.None
    public var validAudiences = Array<String>()
    public var requireExpirationTime = false
    public var authenticationType: String = "AuthenticationTypes.Federation"
}
