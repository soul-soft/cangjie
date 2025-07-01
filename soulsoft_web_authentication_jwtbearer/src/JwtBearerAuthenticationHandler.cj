package soulsoft_web_authentication_jwtbearer

import std.unicode.*
import soulsoft_web_http.*
import soulsoft_identity_tokens.*
import soulsoft_security_claims.*
import soulsoft_web_authentication.*
import soulsoft_extensions_options.*
import soulsoft_extensions_logging.*
import soulsoft_identity_tokens_jwt.*

public class JwtBearerAuthenticationHandler <: AuthenticationHandler<JwtBearerAuthenticationOptions> {
   
    public init(options: IOptions<JwtBearerAuthenticationOptions>, logger: ILoggerFactory) {
        super(options, logger)
    }

    public func handleAuthenticate() {
        if (let Some(accessToken) <- getAccessToken()) {
            let jwtTokenHandler = JwtSecurityTokenHandler()
            let tokenValidationParameters = this.options.tokenValidationParameters
            let result = jwtTokenHandler.validateToken(accessToken, tokenValidationParameters)
            if (result.isValid) {
                let properties = AuthenticationProperties()
                if (this.options.saveToken) {
                    properties.storeTokens(AuthenticationToken("access_token", accessToken))
                }   
                let ticket = AuthenticationTicket(result.subject, JwtBearerAuthenticationDefaults.Scheme, properties)
                return AuthenticateResult.success(ticket)
            }else {
                AuthenticateResult.fail(result.exception.getOrThrow())
            }
        }
        return AuthenticateResult.noResult()
    }

    protected override func handleChallenge(properties: ?AuthenticationProperties): Unit {
        let authenticateResult = handleAuthenticateOnceSafe()
        let error_description = authenticateResult.failure.flatMap{f => f.message} ?? String.empty
        this.context.response.addHeader("WWW-Authenticate", "${this.options.challenge} error=\"invalid_token\", error_description=\"${error_description}\", charset=\"UTF-8\"")
        super.handleChallenge(properties)
    }

    private func getAccessToken(): ?String {
        var accessToken: ?String = if (let Some(onMessageReceived) <- this.options.events.onMessageReceived) {
            onMessageReceived(this.context)
        }else {
            None
        }

        if (accessToken.isNone()) {
            if(let Some(authorizationValue) <- this.context.request.headers.getFirst("Authorization") && startWithBearer(authorizationValue)) {
                accessToken = authorizationValue[7..]
            }
        }
        return accessToken
    }

    private func startWithBearer(authorizationValue: String) {
        return authorizationValue.toUpper().startsWith("BEARER")
    }
}