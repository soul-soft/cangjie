package soulsoft_identity_server

import soulsoft_web_http.*
import soulsoft_web_hosting.*
import soulsoft_identity_tokens.*
import soulsoft_extensions_injection.*
import soulsoft_identity_server.endpoints.*

import soulsoft_identity_server.services.*

main(): Int64 {
    let builer = WebHost.createBuilder()
     
    let rsaSecurityKey = RsaSecurityKey(
        publicKey: SecurityKeyHelper.createRSAPublicKeyFromDerFile("rsa256_public.pem"),
        privateKey: SecurityKeyHelper.createRSAPrivateKeyFromDerFile("rsa256_private.pem"))

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
