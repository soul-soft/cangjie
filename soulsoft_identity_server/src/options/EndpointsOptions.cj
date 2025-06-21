package soulsoft_identity_server.options

import soulsoft_identity_server.constants.*

public class EndpointsOptions {
    public var prefix = ""
    public var enableAuthorizeEndpoint = true
    public var enableJwtRequestUri = true
    public var enableTokenEndpoint  = true
    public var enableUserInfoEndpoint  = true
    public var enableDiscoveryEndpoint  = true
    public var enableEndSessionEndpoint  = true
    public var enableCheckSessionEndpoint  = true
    public var enableTokenRevocationEndpoint  = true
    public var enableIntrospectionEndpoint  = true
    public var enableDeviceAuthorizationEndpoint  = true
    public var enableBackchannelAuthenticationEndpoint  = true
    public var enablePushedAuthorizationEndpoint  = true
}