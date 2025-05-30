package soulsoft_asp.authentication

import stdx.encoding.base64.*
import soulsoft_security_claims.*
import soulsoft_asp_authentication.*
import soulsoft_extensions_logging.*
import soulsoft_extensions_options.*

public class JwtBearerAuthenticationHandler <: AuthenticationHandler<JwtBearerAuthenticationOptions> {
    public init(options: IOptions<JwtBearerAuthenticationOptions>, logger: ILoggerFactory) {
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
                let identity = ClaimsIdentity(this.scheme.name)
                identity.addClaim(Claim("username",username))
                identity.addClaim(Claim("password",password))
                subject.addIdentity(identity)
                let ticket = AuthenticationTicket(subject, JwtBearerAuthenticationDefault.scheme)
                return AuthenticateResult.success(ticket)
            }
        }
        return AuthenticateResult.noResult()
    }

    protected override func handleChallenge(properties: ?AuthenticationProperties): Unit {
        this.context.response.addHeader("WWW-Authenticate", "Basic realm=\"${this.options.realm}\", charset=\"UTF-8\"")
        super.handleChallenge(properties)
    }

}
