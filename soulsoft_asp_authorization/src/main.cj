package soulsoft_asp_authorization

import soulsoft_asp_http.*
import soulsoft_asp_routing.RoutingApplicationBuilderExtensions
import soulsoft_asp_hosting.*
import soulsoft_asp_authentication.AuthenticationApplicationBuilderExtension
import soulsoft_asp_authentication.*
import stdx.encoding.base64.*
import soulsoft_security_claims.*
import soulsoft_extensions_logging.*
import soulsoft_extensions_options.*
import soulsoft_extensions_injection.*

main(args: Array<String>) {
    let builder = WebHost.createBuilder(args)
    builder.services.addAuthentication(BasicAuthenticationDefault.scheme)
        .addScheme<BasicAuthenticationOptions, BasicAuthenticationHandler>(BasicAuthenticationDefault.scheme)
    builder.services.addAuthorization{configure => 
        configure.addPolicy("default") { p=>
            p.requireAuthenticatedUser()
        }
    }
    let host = builder.build()
    host.useEndpoints{endpoints =>
        endpoints.mapGet("hello") { context =>
            context.response.write("hello")
        }.requireAuthorization()
    }
    host.useAuthentication()
    host.useAuthorization()
    host.run()
    return 0
}




public class BasicAuthenticationOptions <: AuthenticationSchemeOptions {
}

public class BasicAuthenticationHandler <: AuthenticationHandler<BasicAuthenticationOptions> {
    public init(options: IOptions<BasicAuthenticationOptions>, logger: ILoggerFactory) {
        super(options, logger)
    }

    public func handleAuthenticate() {
        if (let Some(authorization) <- this.context.request.headers.getFirst("Authorization")
            .flatMap{f => fromBase64String(f.replace("Basic ", "")).flatMap{f=> String.fromUtf8(f)} }) {
           
            let secrets = authorization.split(":")
            if (secrets.size == 2) {
                let username = secrets[0]
                let password = secrets[1]
                this.logger.info("username:${username},password:${password}")    
                let subject = ClaimsPrincipal()
                subject.addIdentity(ClaimsIdentity(Claim("username",username),Claim("password",password)))
                let ticket = AuthenticationTicket(subject, BasicAuthenticationDefault.scheme, properties: None)
                return AuthenticateResult.success(ticket)
            }
        }
        return AuthenticateResult.noResult()
    }
}

public class BasicAuthenticationDefault {
    public static let scheme = "basic"
}