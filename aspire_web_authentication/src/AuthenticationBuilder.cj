package aspire_web_authentication

import std.reflect.*
import aspire_extensions_options.*
import aspire_extensions_injection.*

public class AuthenticationBuilder {
    private let _services: ServiceCollection

    internal init(services: ServiceCollection) {
        _services = services
    }

    public prop services: ServiceCollection {
        get() {
            _services
        }
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
        _services.configure(authenticateScheme, configureOptions)
        _services.addScoped<THandler, THandler>()
        return this
    }
}
