package soulsoft_identity_server

import soulsoft_asp_http.*
import soulsoft_asp_hosting.*
import soulsoft_extensions_injection.*
import soulsoft_identity_server.endpoints.*

import soulsoft_identity_server.services.*

main(): Int64 {
    let builer = WebHost.createBuilder()
    
    builer.services.addIdentityServer{configureOptions =>
        configureOptions.idp = "soulsoft"
        configureOptions.endpoints.prefix = ""
    }
    
    let host = builer.build()
    host.use{ _, next => 
        try {
            next()
        }catch (ex: Exception) {
           ex.printStackTrace()
        }
    }
    host.useIdentityServer()

    host.run()
    return 0
}
