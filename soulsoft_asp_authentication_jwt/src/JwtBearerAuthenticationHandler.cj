package soulsoft_asp_authentication_jwt

import soulsoft_security_jwt.*
import soulsoft_security_claims.*
import soulsoft_asp_authentication.*
import soulsoft_extensions_options.*
import soulsoft_extensions_logging.*

public class JwtBearerAuthenticationHandler <: AuthenticationHandler<JwtBearerAuthenticationOptions> {
   
    public init(options: IOptions<JwtBearerAuthenticationOptions>, logger: ILoggerFactory) {
        super(options, logger)
    }

    public func handleAuthenticate() {
        if (let Some(authorization) <- this.context.request.headers.getFirst("Authorization") && authorization.size > 7) {
            try {
                let accessToken = authorization[7..]
                let jwtTokenHandler = JwtSecurityTokenHandler()
                let tokenValidationParameters = this.options.tokenValidationParameters.getOrThrow()
                let subject = jwtTokenHandler.validateToken(accessToken, tokenValidationParameters)
                let ticket = AuthenticationTicket(subject, JwtBearerAuthenticationDefaults.Scheme)
                return AuthenticateResult.success(ticket)
            }catch (ex: Exception) {
                logger.error(ex.message, ex)
                return AuthenticateResult.fail(ex)
            }
        }
        return AuthenticateResult.noResult()
    }

    protected override func handleChallenge(properties: ?AuthenticationProperties): Unit {
        this.context.response.addHeader("WWW-Authenticate", "${this.options.challenge}, charset=\"UTF-8\"")
        super.handleChallenge(properties)
    }
}