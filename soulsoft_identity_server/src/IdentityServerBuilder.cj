package soulsoft_identity_server

import std.reflect.*
import soulsoft_asp_hosting.*
import soulsoft_extensions_options.*
import soulsoft_extensions_injection.*

import soulsoft_identity_server.options.*
import soulsoft_identity_server.hosting.*
import soulsoft_identity_server.services.*
import soulsoft_identity_server.constants.*
import soulsoft_identity_server.endpoints.*
import soulsoft_identity_server.services.defaults.*

public class IdentityServerBuilder {
    protected let services: ServiceCollection

    protected init(services: ServiceCollection) {
        this.services = services
    }

    public func addEndpoint<TEndpointHandler>(name: String,path: String) where TEndpointHandler <: IEndpointHandler {
        services.addSingleton<EndpointDescriptor>{sp =>
            let options = sp.getOrThrow<IdentityServerOptions>()
            let path = "${options.endpoints.prefix}/${path}"
            return EndpointDescriptor(name, path, TypeInfo.of<TEndpointHandler>())
        }
    }
}

/** core extensions **/
extend IdentityServerBuilder {
    public func addRequiredPlatformEndpoints() {
        addEndpoint<TokenEndpoint>(ConstantEndpointNames.Token, ConstantEndpointPaths.TokenPath)
        addEndpoint<DiscoveryDocumentEndpoint>(ConstantEndpointNames.DiscoveryDocument, ConstantEndpointPaths.DiscoveryDocumentPath)
        addEndpoint<DiscoveryDocumentJwksEndpoint>(ConstantEndpointNames.DiscoveryDocumentJwks, ConstantEndpointPaths.DiscoveryDocumentJwksPath)
        return this
    }

    public func addRequiredPlatformServices() {
        services.addHttpContextAccessor()
        services.tryAddScoped<IServerUrls, ServerUrls>()
        services.tryAddScoped<IClaimService, ClaimsService>()
        services.tryAddSingleton<IEndpointRouter, EndpointRouter>()
        services.tryAddScoped<IDiscoveryDecumentService, DiscoveryDecumentService>()
        services.tryAddSingleton<EndpointDescriptors, EndpointDescriptors>{sp => EndpointDescriptors(sp.getAll<EndpointDescriptor>())}
        return this
    }

    public func name() {
    }
}
