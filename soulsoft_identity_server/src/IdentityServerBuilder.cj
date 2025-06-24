package soulsoft_identity_server

import std.reflect.*
import soulsoft_asp_hosting.*
import soulsoft_extensions_options.*
import soulsoft_extensions_injection.*

import soulsoft_identity_tokens.*
import soulsoft_identity_server.stores.*
import soulsoft_identity_server.options.*
import soulsoft_identity_server.hosting.*
import soulsoft_identity_server.services.*
import soulsoft_identity_server.constants.*
import soulsoft_identity_server.endpoints.*
import soulsoft_identity_server.stores.defaults.*
import soulsoft_identity_server.services.defaults.*

public class IdentityServerBuilder {
    protected let services: ServiceCollection

    protected init(services: ServiceCollection) {
        this.services = services
    }

    public func addSigningCredential(credential: SigningCredentials) {
        addSigningCredentialStore(InMemorySigningCredentialStore(credential))
    }

    public func addSigningCredentialStore<TSigningCredentialStore>() where TSigningCredentialStore <: Object{
        services.addSingleton<ISigningCredentialStore, TSigningCredentialStore>()
    }

    public func addSigningCredentialStore(store: ISigningCredentialStore) {
        services.addSingleton<ISigningCredentialStore>(store)
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
    public func addDefaultEndpoints() {
        addEndpoint<TokenEndpoint>(ConstantEndpointNames.Token, ConstantEndpointPaths.TokenPath)
        addEndpoint<AuthorizeEndpoint>(ConstantEndpointNames.Authorize, ConstantEndpointPaths.AuthorizePath)
        addEndpoint<DiscoveryEndpoint>(ConstantEndpointNames.Discovery, ConstantEndpointPaths.DiscoveryPath)
        addEndpoint<DiscoveryJwksEndpoint>(ConstantEndpointNames.DiscoveryJwks, ConstantEndpointPaths.DiscoveryJwksPath)
        return this
    }

    public func AddPluggableServices() {
        services.addHttpContextAccessor()
        services.tryAddScoped<IServerUrls, ServerUrls>()
        services.tryAddScoped<IClaimService, ClaimsService>()
        services.tryAddSingleton<IEndpointRouter, EndpointRouter>()
        services.tryAddScoped<IDiscoveryDecumentService, DiscoveryDecumentService>()
        services.tryAddSingleton<EndpointManager, EndpointManager>{sp => EndpointManager(sp.getAll<EndpointDescriptor>())}
        services.tryAddSingleton<EndpointManager, EndpointManager>{sp => EndpointManager(sp.getAll<EndpointDescriptor>())}
        return this
    }
}
