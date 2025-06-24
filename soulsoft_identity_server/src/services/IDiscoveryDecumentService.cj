package soulsoft_identity_server.services

import soulsoft_identity_tokens.JsonWebKeySet
import soulsoft_identity_protocols_oidc.OpenIdConnectConfiguration

public interface IDiscoveryDecumentService {
    func createJwksDocument() : JsonWebKeySet
    func createDiscoveryDocument(): OpenIdConnectConfiguration
}