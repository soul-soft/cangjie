package soulsoft_identity_server.endpoints

import soulsoft_asp_http.*
import stdx.serialization.serialization.*
import soulsoft_identity_server.constants.*
import soulsoft_identity_server.hosting.*

public class DiscoveryDocumentEndpoint <: EndpointHandler {
    public func handle(context: HttpContext): IEndpointResult {
       
        return json()
    }
}