package soulsoft_identity_server

import std.reflect.*
import soulsoft_extensions_options.*
import soulsoft_extensions_injection.*

import soulsoft_identity_server.options.*
import soulsoft_identity_server.hosting.*
import soulsoft_identity_server.services.*
import soulsoft_identity_server.endpoints.*

public class IdentityServerBuilder {
    protected let services: ServiceCollection

    init(services: ServiceCollection) {
        this.services = services
    }

    public func addEndpoint<TEndpointHandler>(path: String) where TEndpointHandler <: IEndpointHandler {
        services.addSingleton(EndpointDescriptor(path, TypeInfo.of<TEndpointHandler>()))
    }
}

extend IdentityServerBuilder {
    public func addRequiredPlatformEndpoints() {
        addEndpoint<TokenEndpoint>("connect/token")
        return this
    }

    public func addRequiredPlatformServices() {
        services.tryAddSingleton<IClaimService, ClaimsService>()
        services.tryAddSingleton<IEndpointFactory, EndpointFactory>()
        services.tryAddSingleton<IEndpointRouter, EndpointRouter> {
            sp => EndpointRouter(
                sp.getOrThrow<IEndpointFactory>(), 
                sp.getOrThrow<IdentityServerOptions>(), 
                sp.getAll<EndpointDescriptor>())
        }
        return this
    }

    public func name() {
    }
}
