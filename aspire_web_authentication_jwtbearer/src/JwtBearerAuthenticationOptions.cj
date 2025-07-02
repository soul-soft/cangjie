package aspire_web_authentication_jwtbearer

import aspire_identity_tokens.*
import aspire_web_authentication.*
import aspire_identity_protocols.*
import aspire_identity_protocols_oidc.*

public class JwtBearerAuthenticationOptions <: AuthenticationSchemeOptions {
    public var saveToken = true
    public var metadataAddress = ""
    public var authority: ?String = None
    public var requireHttpsMetadata = false
    public let events = JwtBearerAuthenticationEvents()
    public var challenge = JwtBearerAuthenticationDefaults.Scheme
    public var configuration: ?OpenIdConnectConfiguration = None
    public var configurationManager: ?IConfigurationManager<OpenIdConnectConfiguration> = None
    public var tokenValidationParameters: TokenValidationParameters = TokenValidationParameters()
}
