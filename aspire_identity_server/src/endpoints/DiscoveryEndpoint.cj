package aspire_identity_server.endpoints

import aspire_web_http.*
import aspire_identity_server.hosting.*
import aspire_identity_protocols_oidc.*
import aspire_identity_server.services.*

public class DiscoveryEndpoint <: EndpointHandler {
    private let _discoveryDecument: IDiscoveryDecumentService

    public init(discoveryDecument: IDiscoveryDecumentService) {
        _discoveryDecument = discoveryDecument
    }

    public func handle(_: HttpContext): IEndpointResult {
        let document = _discoveryDecument.createDiscoveryDocument()
        return json(OpenIdConnectConfiguration.wirte(document))
    }
}
