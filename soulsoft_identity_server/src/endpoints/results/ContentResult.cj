package soulsoft_identity_server.endpoints.results

import soulsoft_asp_http.*
import stdx.serialization.serialization.*
import soulsoft_identity_server.hosting.*

public class ContentResult <: IEndpointResult {
    public ContentResult(let data: String,let contentType: String) {
        
    }

    public func execute(context: HttpContext) {
        context.response.write(data)
        context.response.addHeader("content-type", contentType)
    }
}