package soulsoft_identity_server.endpoints.results

import soulsoft_asp_http.*
import soulsoft_identity_server.hosting.*

public class StatusResult <: IEndpointResult {
   
    public StatusResult(let status: UInt16) {
    }
   
    public func execute(context: HttpContext) {
        context.response.status(this.status)
    }
}