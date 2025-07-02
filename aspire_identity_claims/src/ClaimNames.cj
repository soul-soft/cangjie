package aspire_identity_claims

public abstract class ClaimNames {
    // Standard JWT Claims (RFC 7519)
    public static let Issuer = "iss"
    public static let Subject = "sub"
    public static let Audience = "aud"
    public static let ExpirationTime = "exp"
    public static let NotBefore = "nbf"
    public static let IssuedAt = "iat"
    public static let JwtId = "jti"
    
    // Common Profile Claims
    public static let Name = "name"
    public static let GivenName = "given_name"
    public static let FamilyName = "family_name"
    public static let MiddleName = "middle_name"
    public static let Nickname = "nickname"
    public static let PreferredUsername = "preferred_username"
    public static let Profile = "profile"
    public static let Picture = "picture"
    public static let Website = "website"
    public static let Email = "email"
    public static let EmailVerified = "email_verified"
    public static let Gender = "gender"
    public static let Birthdate = "birthdate"
    public static let Zoneinfo = "zoneinfo"
    public static let Locale = "locale"
    public static let PhoneNumber = "phone_number"
    public static let PhoneNumberVerified = "phone_number_verified"
    public static let Address = "address"
    
    // Authentication Context
    public static let AuthTime = "auth_time"
    public static let Nonce = "nonce"
    public static let Acr = "acr"
    public static let Amr = "amr"
    public static let Azp = "azp"
    
    // Role/Permission Claims
    public static let Role = "role"
    public static let Roles = "roles"
    public static let Scope = "scope"
    public static let Permissions = "permissions"
    
    // Custom/Organization Claims
    public static let TenantId = "tenant_id"
    public static let ClientId = "client_id"
    public static let UserId = "user_id"
    public static let EmployeeId = "employee_id"
    
    // OAuth Claims
    public static let AccessTokenHash = "at_hash"
    public static let CodeHash = "c_hash"
}