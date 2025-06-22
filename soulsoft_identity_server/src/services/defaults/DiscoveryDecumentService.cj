package soulsoft_identity_server.services.defaults

import soulsoft_identity_server.hosting.*
import soulsoft_identity_server.options.*
import soulsoft_identity_protocols_oidc.*
import soulsoft_identity_server.services.*
import soulsoft_identity_server.constants.*

public class DiscoveryDecumentService <: IDiscoveryDecumentService {
    private let _options: IdentityServerOptions
    private let _serverUrls: IServerUrls
    private let _descriptors: EndpointDescriptors

    public init(options: IdentityServerOptions, serverUrls: IServerUrls, descriptors: EndpointDescriptors) {
        _options = options   
        _serverUrls = serverUrls
        _descriptors = descriptors
    }
    
    public func getDiscoveryDocument(): String {
        let configuration = OpenIdConnectConfiguration()
        configuration.issuer = _options.issuer
        //endpoints
        for (pattern in _descriptors.items) {
            if (pattern.name == ConstantEndpointNames.Token && _options.endpoints.enableTokenEndpoint) {
                configuration.tokenEndpoint = "${_serverUrls.url}${pattern.path}"
            }
            else if (pattern.name == ConstantEndpointNames.Authorize && _options.endpoints.enableAuthorizeEndpoint) {
                configuration.authorizationEndpoint = "${_serverUrls.url}${pattern.path}"
            }
            else if (pattern.name == ConstantEndpointNames.DiscoveryDocumentJwks && _options.endpoints.enableJwtRequestUri) {
                configuration.jwksUri = "${_serverUrls.url}${pattern.path}"
            }
        }
        let json = OpenIdConnectConfiguration.wirte(configuration)
        return json
    }

    public func getDiscoveryDocumentJwks() : String {
        return String.empty
    }
}