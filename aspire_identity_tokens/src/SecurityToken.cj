package aspire_identity_tokens

public abstract class SecurityToken {
    public prop id: ?String
    public prop issuer: ?String
    public prop signingKey: SecurityKey
}