package soulsoft_identity_server

import soulsoft_extensions_options.*
import soulsoft_extensions_injection.*

import soulsoft_identity_server.options.*
import soulsoft_identity_server.services.*

public interface IdentityServiceExtensions {
    func addIdentityServer(): ServiceCollection {
        addIdentityServer({_=>})
    }
    func addIdentityServer(configureOptions: (IdentityServerOptions)->Unit): ServiceCollection
    func addIdentityServerBuilder(configureOptions: (IdentityServerOptions)->Unit): IdentityServerBuilder
}

extend ServiceCollection <: IdentityServiceExtensions {

    public func addIdentityServer(configureOptions: (IdentityServerOptions)->Unit) {
        addIdentityServerBuilder(configureOptions)
            .addDefaultEndpoints()
            .AddPluggableServices()
        return this
    }

    public func addIdentityServerBuilder(configureOptions: (IdentityServerOptions)->Unit) : IdentityServerBuilder {
        this.configure(configureOptions)
        addSingleton<IdentityServerOptions>{sp => sp.getOrThrow<IOptions<IdentityServerOptions>>().value}
        return IdentityServerBuilder(this)
    }
}