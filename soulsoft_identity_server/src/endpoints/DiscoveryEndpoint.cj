package soulsoft_identity_server.endpoints

import soulsoft_asp_http.*
import soulsoft_identity_server.hosting.*
import soulsoft_identity_server.services.*

public class DiscoveryEndpoint <: EndpointHandler {
    private let _discoveryDecument: IDiscoveryDecumentService

    public init(discoveryDecument: IDiscoveryDecumentService) {
        _discoveryDecument = discoveryDecument
    }

    public func handle(_: HttpContext): IEndpointResult {
        let document = _discoveryDecument.createDiscoveryDocument()
        return json(document)
    }
}
