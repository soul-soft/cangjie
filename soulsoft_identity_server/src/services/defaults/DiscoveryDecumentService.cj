package soulsoft_identity_server.services.defaults

import soulsoft_identity_tokens.*

import soulsoft_identity_server.hosting.*
import soulsoft_identity_server.options.*
import soulsoft_identity_protocols_oidc.*
import soulsoft_identity_server.services.*
import soulsoft_identity_server.constants.*

public class DiscoveryDecumentService <: IDiscoveryDecumentService {

    public DiscoveryDecumentService(
        let options: IdentityServerOptions,
        let serverUrls: IServerUrls, 
        let keyManager: IKeyManager ,
        let endpoints: EndpointManager) {
    }
    
    public func createDiscoveryDocument(): String {
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
        let json = OpenIdConnectConfiguration.wirte(configuration)
        return json
    }

    public func createJwksDocument() : String {
        if (options.dsicovery.showKeySet) {
            let signingCredentials = keyManager.getActiveSigningKeys()
            for (pattern in signingCredentials) {
               if (let rsa: RsaSecurityKey <- pattern.key) {
                
               } else if (let rsa: ECDsaSecurityKey <- pattern.key) {
                    
               } 
            }
        }
        return String.empty
    }
}