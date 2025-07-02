package aspire_web_authentication_jwtbearer

import aspire_identity_protocols.*
import aspire_web_authentication.*
import aspire_extensions_options.*
import aspire_extensions_injection.*
import aspire_identity_protocols_oidc.*

public interface JwtBearerAuthenticationBuilderExtensions {
    func addJwtBearer(authenticateScheme: String, displayName: Option<String>, configureOptions: (JwtBearerAuthenticationOptions) -> Unit): AuthenticationBuilder

    func addJwtBearer(authenticateScheme: String, configureOptions: (JwtBearerAuthenticationOptions) -> Unit): AuthenticationBuilder {
        addJwtBearer(authenticateScheme, None, configureOptions)
    }

    func addJwtBearer(configureOptions: (JwtBearerAuthenticationOptions) -> Unit): AuthenticationBuilder {
        addJwtBearer(JwtBearerAuthenticationDefaults.Scheme, None, configureOptions)
    }
}

extend AuthenticationBuilder <: JwtBearerAuthenticationBuilderExtensions {
    public func addJwtBearer(authenticateScheme: String, displayName: Option<String>, configureOptions: (JwtBearerAuthenticationOptions) -> Unit): AuthenticationBuilder {
        services.configureAfter<JwtBearerAuthenticationOptions>{configureOptions =>
            if (configureOptions.configurationManager.isNone()) {
                if (let Some(configuration) <- configureOptions.configuration) {
                    configureOptions.configurationManager = StaticConfigurationManager<OpenIdConnectConfiguration>(configuration)
                }else {
                    let address: String = if (!configureOptions.metadataAddress.isEmpty()) {
                        configureOptions.metadataAddress
                    }else if(let Some(authority) <- configureOptions.authority) {
                        "${authority}/.well-known/openid-configuration"
                    }else {
                        throw NoneValueException("Please configure either 'authority' or 'metadataAddress'.")
                    }
                    let documentRetriever = HttpDocumentRetriever(requireHttps: configureOptions.requireHttpsMetadata)
                    let configurationRetriever = OpenIdConnectConfigurationRetriever()
                    configureOptions.configurationManager = ConfigurationManager<OpenIdConnectConfiguration>(address, documentRetriever, configurationRetriever)
                }
            }
        }
        this.addScheme<JwtBearerAuthenticationOptions, JwtBearerAuthenticationHandler>(authenticateScheme, displayName, configureOptions)
    }
}