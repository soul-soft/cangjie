package aspire_identity_protocols_oidc

import aspire_identity_protocols.*

public class OpenIdConnectConfigurationRetriever <: IConfigurationRetriever<OpenIdConnectConfiguration> {
    public func getConfiguration(address: String, documentRetriever: IDocumentRetriever): OpenIdConnectConfiguration {
        let document = documentRetriever.getDocument(address)
        return OpenIdConnectConfiguration.create(document)
    }
}