package aspire_identity_server.options

import aspire_identity_server.constants.*

public class EndpointsOptions {
    public var prefix = ""
    public var enableJwtRequestUri = true
    public var enableTokenEndpoint  = true
    public var enableUserInfoEndpoint  = true
    public var enableAuthorizeEndpoint = true
    public var enableDiscoveryEndpoint  = true
    public var enableEndSessionEndpoint  = true
    public var enableCheckSessionEndpoint  = true
    public var enableTokenRevocationEndpoint  = true
    public var enableIntrospectionEndpoint  = true
    public var enableDeviceAuthorizationEndpoint  = true
    public var enableBackchannelAuthenticationEndpoint  = true
    public var enablePushedAuthorizationEndpoint  = true

    public func isEnable(name: String) {
        if (name == ConstantEndpointNames.Token) {
            return enableTokenEndpoint
        }
        if (name == ConstantEndpointNames.UserInfo) {
            return enableUserInfoEndpoint
        }
        if (name == ConstantEndpointNames.Authorize) {
            return enableAuthorizeEndpoint
        }
        if (name == ConstantEndpointNames.Discovery) {
            return enableDiscoveryEndpoint
        }
        if (name == ConstantEndpointNames.DiscoveryJwks) {
            return enableJwtRequestUri
        }
        if (name == ConstantEndpointNames.Introspection) {
            return enableIntrospectionEndpoint
        }
        return true
    }
}