package aspire_identity_server.hosting

import aspire_web_http.*
import stdx.serialization.serialization.*

public class ContentEndpointResult <: IEndpointResult {
    public ContentEndpointResult(let data: String, let contentType: String) {
    }

    public func execute(context: HttpContext) {
        context.response.write(data)
        context.response.addHeader("content-type", contentType)
    }
}
