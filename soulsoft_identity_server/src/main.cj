package soulsoft_identity_server

import soulsoft_asp_http.*
import soulsoft_asp_hosting.*
import soulsoft_extensions_injection.*
import soulsoft_identity_server.endpoints.*

main(): Int64 {
    let builer = WebHost.createBuilder()
    
    builer.services.addIdentityServer{configureOptions =>
        configureOptions.idp = "soulsoft"
    }
    
    let host = builer.build()
    
    host.useIdentityServer()

    host.run()
    return 0
}
