package aspire_identity_server.services

import aspire_identity_tokens.JsonWebKeySet
import aspire_identity_protocols_oidc.OpenIdConnectConfiguration

public interface IDiscoveryDecumentService {
    func createJwksDocument() : JsonWebKeySet
    func createDiscoveryDocument(): OpenIdConnectConfiguration
}