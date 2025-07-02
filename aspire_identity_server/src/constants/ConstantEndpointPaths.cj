package aspire_identity_server.constants

public class ConstantEndpointPaths {
    public static let AuthorizePath = "connect/authorize"
    public static let DiscoveryPath = ".well-known/openid-configuration"
    public static let DiscoveryJwksPath = DiscoveryPath + "/jwks"
    public static let TokenPath = "connect/token"
    public static let UserInfoPath = "connect/userinfo"
    public static let RevocationPath = "connect/revocation"
    public static let IntrospectionPath = "connect/introspect"
    public static let EndSessionPath = "connect/endsession"
    public static let EndSessionCallbackPath = "connect/endsession-callback"
}