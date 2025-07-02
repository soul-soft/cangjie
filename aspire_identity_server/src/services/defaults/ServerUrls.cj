package aspire_identity_server.services.defaults

import aspire_web_http.*
import aspire_identity_server.options.*
import aspire_identity_server.services.*

public class ServerUrls <: IServerUrls {
    private let _options: IdentityServerOptions
    private let _httpContextAccessor: IHttpContextAccessor

    public init(options: IdentityServerOptions, httpContextAccessor: IHttpContextAccessor) {
        _options = options
        _httpContextAccessor = httpContextAccessor
    }

    public prop url: String {
        get() {
            if (_options.issuerUri.size > 0) {
                return _options.issuerUri
            }
            let context = _httpContextAccessor.context.getOrThrow()
            return "${context.request.host}"
        }
    }
}
