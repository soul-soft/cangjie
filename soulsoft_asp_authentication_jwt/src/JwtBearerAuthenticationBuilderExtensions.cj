package soulsoft_asp_authentication_jwt

import soulsoft_asp_authentication.*

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
        this.addScheme<JwtBearerAuthenticationOptions, JwtBearerAuthenticationHandler>(authenticateScheme, displayName, configureOptions)
    }
}