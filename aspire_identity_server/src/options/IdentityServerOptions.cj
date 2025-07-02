package aspire_identity_server.options

public class IdentityServerOptions {
    public var idp = ""
    public var issuer = ""
    public var issuerUri = ""
    public let endpoints = EndpointsOptions()
    public let dsicovery = DiscoveryOptions()
}