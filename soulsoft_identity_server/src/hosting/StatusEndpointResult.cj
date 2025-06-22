package soulsoft_identity_server.hosting

import soulsoft_asp_http.*

public class StatusEndpointResult <: IEndpointResult {
   
    public StatusEndpointResult(let status: UInt16) {
    }
   
    public func execute(context: HttpContext) {
        context.response.status(this.status)
    }
}