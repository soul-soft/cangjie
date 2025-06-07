package soulsoft_asp_authentication_jwtbearer

import soulsoft_security_claims.*
import std.unicode.UnicodeStringExtension
import soulsoft_asp_authentication.*
import soulsoft_extensions_options.*
import soulsoft_extensions_logging.*
import soulsoft_security_tokens_jwt.*

public class JwtBearerAuthenticationHandler <: AuthenticationHandler<JwtBearerAuthenticationOptions> {
   
    public init(options: IOptions<JwtBearerAuthenticationOptions>, logger: ILoggerFactory) {
        super(options, logger)
    }

    public func handleAuthenticate() {
        if (let Some(authorizationValue) <- this.context.request.headers.getFirst("Authorization") && isJwtBearer(authorizationValue)) {
            try {
                let accessToken = authorizationValue[7..]
                let jwtTokenHandler = JwtSecurityTokenHandler()
                let tokenValidationParameters = this.options.tokenValidationParameters
                let subject = jwtTokenHandler.validateToken(accessToken, tokenValidationParameters)
                let ticket = AuthenticationTicket(subject, JwtBearerAuthenticationDefaults.Scheme)
                return AuthenticateResult.success(ticket)
            }catch (ex: Exception) {
                return AuthenticateResult.fail(ex)
            }
        }
        return AuthenticateResult.noResult()
    }

    protected override func handleChallenge(properties: ?AuthenticationProperties): Unit {
        this.context.response.addHeader("WWW-Authenticate", "${this.options.challenge}, charset=\"UTF-8\"")
        super.handleChallenge(properties)
    }

    private func isJwtBearer(authorizationValue: String) {
        return authorizationValue.toUpper().startsWith("BEARER")
    }
}