package aspire_identity_server.hosting

import aspire_web_http.*

public class StatusEndpointResult <: IEndpointResult {
    public StatusEndpointResult(let status: UInt16) {
    }

    public func execute(context: HttpContext) {
        context.response.status(this.status)
    }
}
