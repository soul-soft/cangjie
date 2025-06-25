package soulsoft_identity_server

import soulsoft_asp_http.*
import soulsoft_asp_hosting.*
import soulsoft_identity_tokens.*
import soulsoft_extensions_injection.*
import soulsoft_identity_server.endpoints.*

import soulsoft_identity_server.services.*

main(): Int64 {
    let builer = WebHost.createBuilder()
    let rsaSecurityKey = RsaSecurityKey.create()
    rsaSecurityKey.importPublicKeyFromPemFile("rsa256_public.pem")
    rsaSecurityKey.importPrivateKeyFromPemFile("rsa256_private.pem")
    builer.services.addIdentityServer({ configureOptions =>
        configureOptions.idp = "soulsoft"
        configureOptions.issuer = "soulsoft"
        configureOptions.issuerUri = "http://localhost:5000"
    })
    .addSigningCredential(SigningCredentials(rsaSecurityKey, SecurityAlgorithms.RsaSha256))
    
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
