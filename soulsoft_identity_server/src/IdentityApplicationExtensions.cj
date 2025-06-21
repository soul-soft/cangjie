package soulsoft_identity_server

import soulsoft_asp_http.*
import soulsoft_identity_server.hosting.*

public interface IdentityApplicationExtensions {
    func useIdentityServer(): Unit
}

extend ApplicationBuilder <: IdentityApplicationExtensions {
    public func useIdentityServer(): Unit {
        this.use<IdentityServerMiddleware>()
    }
}
