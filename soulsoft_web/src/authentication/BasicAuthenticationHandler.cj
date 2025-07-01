package soulsoft_web.authentication

import stdx.encoding.base64.*
import soulsoft_security_claims.*
import soulsoft_web_authentication.*
import soulsoft_extensions_logging.*
import soulsoft_extensions_options.*

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
                let validator = this.context.services.getOrThrow<IResourceOwnerPasswordValidator>()
                if (!validator.validate(username, password)) {
                    return AuthenticateResult.fail(Exception("Invalid username or password"))
                }
                let subject = ClaimsPrincipal()
                let identity = ClaimsIdentity(this.scheme.name)
                identity.addClaim(Claim("username",username))
                identity.addClaim(Claim("password",password))
                subject.addIdentity(identity)
                let ticket = AuthenticationTicket(subject, BasicAuthenticationDefault.Scheme)
                return AuthenticateResult.success(ticket)
            }
        }
        return AuthenticateResult.noResult()
    }

    /*
    发起挑战：401
    */
    protected override func handleChallenge(properties: ?AuthenticationProperties): Unit {
        this.context.response.addHeader("WWW-Authenticate", "Basic realm=\"${this.options.realm}\", charset=\"UTF-8\"")
        super.handleChallenge(properties)
    }

}
