package soulsoft_asp_authentication

import std.reflect.*
import soulsoft_extensions_options.*
import soulsoft_extensions_injection.*

public class AuthenticationBuilder {
    private let _services: ServiceCollection

    internal init(services: ServiceCollection) {
        _services = services
    }

    public func addScheme<TOptions, THandler>(authenticateScheme: String): AuthenticationBuilder where TOptions <: AuthenticationSchemeOptions,
        THandler <: AuthenticationHandler<TOptions> {
        addSchemeHelper<TOptions, THandler>(authenticateScheme, None) { _ =>

        }
        return this
    }

    public func addScheme<TOptions, THandler>(authenticateScheme: String,
        configureOptions: (TOptions) -> Unit): AuthenticationBuilder where TOptions <: AuthenticationSchemeOptions,
        THandler <: AuthenticationHandler<TOptions> {
        addSchemeHelper<TOptions, THandler>(authenticateScheme, None, configureOptions)
        return this
    }

    public func addScheme<TOptions, THandler>(authenticateScheme: String, displayName: ?String,
        configureOptions: (TOptions) -> Unit): AuthenticationBuilder where TOptions <: AuthenticationSchemeOptions,
        THandler <: AuthenticationHandler<TOptions> {
        addSchemeHelper<TOptions, THandler>(authenticateScheme, displayName, configureOptions)
        return this
    }

    private func addSchemeHelper<TOptions, THandler>(authenticateScheme: String, displayName: ?String,
        configureOptions: (TOptions) -> Unit): AuthenticationBuilder where TOptions <: AuthenticationSchemeOptions,
        THandler <: AuthenticationHandler<TOptions> {
        _services.configure<AuthenticationOptions> {options => 
            options.addScheme(authenticateScheme) { configureBuilder =>
                configureBuilder.displyName = displayName
                configureBuilder.handleType = TypeInfo.of<THandler>()
            }
        }
        _services.addScoped<THandler, THandler>()
        _services.configure(configureOptions)
        return this
    }
}
