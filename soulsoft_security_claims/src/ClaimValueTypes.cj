package soulsoft_security_claims

public abstract class ClaimValueTypes {
    // Primitive Types
    public static let String = "http://www.w3.org/2001/XMLSchema#string"
    public static let Integer = "http://www.w3.org/2001/XMLSchema#integer"
    public static let Boolean = "http://www.w3.org/2001/XMLSchema#boolean"
    public static let DateTime = "http://www.w3.org/2001/XMLSchema#dateTime"
    public static let Date = "http://www.w3.org/2001/XMLSchema#date"
    
    // Security/Identity Types
    public static let Json = "urn:ietf:params:oauth:token-type:json"
    public static let jwt = "urn:ietf:params:oauth:token-type:jwt"
    public static let Saml = "urn:oasis:names:tc:SAML:2.0:assertion"
    public static let Saml11 = "urn:oasis:names:tc:SAML:1.0:assertion"
    public static let Saml2 = "urn:oasis:names:tc:SAML:2.0:assertion"
    
    // OAuth/OpenID Connect Types
    public static let Oauth = "urn:ietf:params:oauth:token-type:oauth"
    public static let AccessToken = "urn:ietf:params:oauth:token-type:access_token"
    public static let RefreshToken = "urn:ietf:params:oauth:token-type:refresh_token"
    public static let IdToken = "urn:ietf:params:oauth:token-type:id_token"
    
    // Common Claim Formats
    public static let Email = "urn:ietf:params:oauth:token-type:email"
    public static let Phone = "urn:ietf:params:oauth:token-type:phone"
    public static let Uri = "http://www.w3.org/2001/XMLSchema#anyURI"
    
    // Specialized Types
    public static let Base64Binary = "http://www.w3.org/2001/XMLSchema#base64Binary"
    public static let HexBinary = "http://www.w3.org/2001/XMLSchema#hexBinary"
    public static let Rfc822Name = "urn:oasis:names:tc:xacml:1.0:data-type:rfc822Name"
    
    // JSON Types
    public static let JsonArray = "urn:ietf:params:oauth:token-type:json-array"
    public static let JsonObject = "urn:ietf:params:oauth:token-type:json-object"
    
    // Custom/Enterprise Types
    public static let Guid = "urn:ietf:params:oauth:token-type:guid"
    public static let Uuid = "urn:ietf:params:oauth:token-type:uuid"
}