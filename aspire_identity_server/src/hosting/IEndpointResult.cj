package aspire_identity_server.hosting

import aspire_web_http.*

public interface IEndpointResult {
    func execute(context: HttpContext): Unit
}