package soulsoft_identity_server.services.defaults

import soulsoft_asp_http.*
import soulsoft_identity_server.options.*
import soulsoft_identity_server.services.*

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
            println(context.request.host)
            return "${context.request.host}"
        }
    }
}
