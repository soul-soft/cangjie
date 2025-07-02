package aspire_identity_server.services.defaults

import std.collection.*

import aspire_identity_tokens.*
import aspire_identity_server.hosting.*
import aspire_identity_server.options.*
import aspire_identity_protocols_oidc.*
import aspire_identity_protocols_oidc.*
import aspire_identity_server.services.*
import aspire_identity_server.constants.*

public class DiscoveryDecumentService <: IDiscoveryDecumentService {

    public DiscoveryDecumentService(
        let serverUrls: IServerUrls, 
        let keyManager: IKeyManager,
        let endpoints: EndpointManager,
        let options: IdentityServerOptions) {
    }
    
    public func createDiscoveryDocument(): OpenIdConnectConfiguration {
        let configuration = OpenIdConnectConfiguration()
        configuration.issuer = options.issuer
        //endpoints
        if (options.dsicovery.showEndpoints) {
            for (pattern in endpoints) {
                let endpointUri = "${serverUrls.url}${pattern.path}"
                if (pattern.name == ConstantEndpointNames.Token && options.endpoints.enableTokenEndpoint) {
                    configuration.tokenEndpoint = endpointUri
                }
                else if (pattern.name == ConstantEndpointNames.Authorize && options.endpoints.enableAuthorizeEndpoint) {
                    configuration.authorizationEndpoint = endpointUri
                }
                else if (pattern.name == ConstantEndpointNames.DiscoveryJwks && options.endpoints.enableJwtRequestUri) {
                    configuration.jwksUri = endpointUri
                }
            }
        }
        return configuration
    }

    public func createJwksDocument() : JsonWebKeySet {
        let jwks = JsonWebKeySet()
        if (options.dsicovery.showKeySet) {
            let signingCredentials = keyManager.getActiveSigningKeys()
            for (pattern in signingCredentials) {
                jwks.keys.add(JsonWebKeyConverter.convert(pattern))
            }
        }
        return jwks
    }
}
