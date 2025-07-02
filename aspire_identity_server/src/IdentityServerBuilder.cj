package aspire_identity_server

import std.reflect.*
import aspire_web_hosting.*
import aspire_extensions_options.*
import aspire_extensions_injection.*

import aspire_identity_tokens.*
import aspire_identity_server.stores.*
import aspire_identity_server.options.*
import aspire_identity_server.hosting.*
import aspire_identity_server.services.*
import aspire_identity_server.constants.*
import aspire_identity_server.endpoints.*
import aspire_identity_server.stores.defaults.*
import aspire_identity_server.services.defaults.*

public class IdentityServerBuilder {
    protected let services: ServiceCollection

    protected init(services: ServiceCollection) {
        this.services = services
    }

    public func addSigningCredential(signingCredentials: ()->SigningCredentials) {
        addSigningCredentialStore(InMemorySigningCredentialStore(signingCredentials()))
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
        services.tryAddScoped<ITokenService, TokenService>()
        services.tryAddScoped<IClaimService, ClaimsService>()
        services.tryAddSingleton<IEndpointRouter, EndpointRouter>()
        services.tryAddScoped<IDiscoveryDecumentService, DiscoveryDecumentService>()
        services.tryAddScoped<IKeyManager, KeyManager>{sp => KeyManager(sp.getAll<ISigningCredentialStore>())}
        services.tryAddSingleton<EndpointManager, EndpointManager>{sp => EndpointManager(sp.getAll<EndpointDescriptor>())}
        return this
    }
}
