package soulsoft_identity_server.constants

public class ConstantEndpointPaths {
    public static let AuthorizePath = "connect/authorize"
    public static let DiscoveryDocumentPath = ".well-known/openid-configuration"
    public static let DiscoveryDocumentJwksPath = DiscoveryDocumentPath + "/jwks"
    public static let TokenPath = "connect/token"
    public static let UserInfoPath = "connect/userinfo"
    public static let RevocationPath = "connect/revocation"
    public static let IntrospectionPath = "connect/introspect"
    public static let EndSessionPath = "connect/endsession"
    public static let EndSessionCallbackPath = "connect/endsession-callback"
}