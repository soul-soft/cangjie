package soulsoft_asp_authentication

import soulsoft_extensions_options.*
import soulsoft_extensions_injection.*

public interface AuthenticationServiceCollectionExtensions {
    func addAuthentication(): AuthenticationBuilder
    func addAuthentication(defaultScheme: String): AuthenticationBuilder
    func addAuthentication(configureOptions: (AuthenticationOptions) -> Unit): AuthenticationBuilder
}

extend ServiceCollection <: AuthenticationServiceCollectionExtensions {
    public func addAuthentication(): AuthenticationBuilder {
        addAuthentication {_ =>}
    }

    public func addAuthentication(defaultScheme: String): AuthenticationBuilder {
        addAuthentication { configureOptions => 
            configureOptions.defaultScheme = defaultScheme
        }
    }

    public func addAuthentication(configureOptions: (AuthenticationOptions) -> Unit): AuthenticationBuilder {
        this.configure(configureOptions)
        this.tryAddScoped<IAuthenticationService, AuthenticationService>()
        this.tryAddSingleton<IAuthenticationSchemeProvider, AuthenticationSchemeProvider>()
        this.tryAddSingleton<IAuthenticationHandlerProvider, AuthenticationHandlerProvider>()
        return AuthenticationBuilder(this)
    }
}
