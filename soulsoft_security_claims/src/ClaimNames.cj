package soulsoft_security_claims

public abstract class ClaimNames {
    // Standard JWT Claims (RFC 7519)
    public static let issuer = "iss"
    public static let subject = "sub"
    public static let audience = "aud"
    public static let expirationTime = "exp"
    public static let notBefore = "nbf"
    public static let issuedAt = "iat"
    public static let jwtId = "jti"
    
    // Common Profile Claims
    public static let name = "name"
    public static let givenName = "given_name"
    public static let familyName = "family_name"
    public static let middleName = "middle_name"
    public static let nickname = "nickname"
    public static let preferredUsername = "preferred_username"
    public static let profile = "profile"
    public static let picture = "picture"
    public static let website = "website"
    public static let email = "email"
    public static let emailVerified = "email_verified"
    public static let gender = "gender"
    public static let birthdate = "birthdate"
    public static let zoneinfo = "zoneinfo"
    public static let locale = "locale"
    public static let phoneNumber = "phone_number"
    public static let phoneNumberVerified = "phone_number_verified"
    public static let address = "address"
    
    // Authentication Context
    public static let authTime = "auth_time"
    public static let nonce = "nonce"
    public static let acr = "acr"
    public static let amr = "amr"
    public static let azp = "azp"
    
    // Role/Permission Claims
    public static let role = "role"
    public static let roles = "roles"
    public static let scope = "scope"
    public static let permissions = "permissions"
    
    // Custom/Organization Claims
    public static let tenantId = "tenant_id"
    public static let clientId = "client_id"
    public static let userId = "user_id"
    public static let employeeId = "employee_id"
    
    // OAuth Claims
    public static let accessTokenHash = "at_hash"
    public static let codeHash = "c_hash"
}