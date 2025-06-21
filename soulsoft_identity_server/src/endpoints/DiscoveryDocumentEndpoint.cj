package soulsoft_identity_server.endpoints

import soulsoft_asp_http.*
import soulsoft_identity_server.hosting.*
import stdx.serialization.serialization.*
import soulsoft_identity_server.services.*
import soulsoft_identity_server.constants.*

public class DiscoveryDocumentEndpoint <: EndpointHandler {
    private let _discoveryDecument: IDiscoveryDecumentService

    public init(discoveryDecument: IDiscoveryDecumentService) {
        _discoveryDecument = discoveryDecument
    }

    public func handle(_: HttpContext): IEndpointResult {
        let document = _discoveryDecument.getDiscoveryDocument()
        return json(document)
    }
}
