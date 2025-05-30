package soulsoft_security_claims

public abstract class ClaimValueTypes {
    // Primitive Types
    public let string = "http://www.w3.org/2001/XMLSchema#string"
    public let integer = "http://www.w3.org/2001/XMLSchema#integer"
    public let boolean = "http://www.w3.org/2001/XMLSchema#boolean"
    public let dateTime = "http://www.w3.org/2001/XMLSchema#dateTime"
    public let date = "http://www.w3.org/2001/XMLSchema#date"
    
    // Security/Identity Types
    public let json = "urn:ietf:params:oauth:token-type:json"
    public let jwt = "urn:ietf:params:oauth:token-type:jwt"
    public let saml = "urn:oasis:names:tc:SAML:2.0:assertion"
    public let saml11 = "urn:oasis:names:tc:SAML:1.0:assertion"
    public let saml2 = "urn:oasis:names:tc:SAML:2.0:assertion"
    
    // OAuth/OpenID Connect Types
    public let oauth = "urn:ietf:params:oauth:token-type:oauth"
    public let accessToken = "urn:ietf:params:oauth:token-type:access_token"
    public let refreshToken = "urn:ietf:params:oauth:token-type:refresh_token"
    public let idToken = "urn:ietf:params:oauth:token-type:id_token"
    
    // Common Claim Formats
    public let email = "urn:ietf:params:oauth:token-type:email"
    public let phone = "urn:ietf:params:oauth:token-type:phone"
    public let uri = "http://www.w3.org/2001/XMLSchema#anyURI"
    
    // Specialized Types
    public let base64Binary = "http://www.w3.org/2001/XMLSchema#base64Binary"
    public let hexBinary = "http://www.w3.org/2001/XMLSchema#hexBinary"
    public let rfc822Name = "urn:oasis:names:tc:xacml:1.0:data-type:rfc822Name"
    
    // JSON Types
    public let jsonArray = "urn:ietf:params:oauth:token-type:json-array"
    public let jsonObject = "urn:ietf:params:oauth:token-type:json-object"
    
    // Custom/Enterprise Types
    public let guid = "urn:ietf:params:oauth:token-type:guid"
    public let uuid = "urn:ietf:params:oauth:token-type:uuid"
}