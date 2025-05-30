package soulsoft_asp_authorization

import soulsoft_extensions_options.*
import soulsoft_extensions_injection.*

public interface AuthorizationServiceCollectionExtensions {
    func addAuthorization(): ServiceCollection {
        addAuthorization{_=>}
    }

    func addAuthorization(configure: (AuthorizationOptions) -> Unit): ServiceCollection

    func addAuthorizationCore(): ServiceCollection {
        addAuthorizationCore {_ =>}
    }

    func addAuthorizationCore(configure: (AuthorizationOptions) -> Unit): ServiceCollection
}

extend ServiceCollection <: AuthorizationServiceCollectionExtensions {
    public func addAuthorizationCore(configure: (AuthorizationOptions) -> Unit): ServiceCollection {
        this.configure(configure)
        this.tryAddTransient<IAuthorizationService, DefaultAuthorizationService> {
            sp => DefaultAuthorizationService(
                sp.getOrThrow<IAuthorizationPolicyProvider>(),
                sp.getOrThrow<IAuthorizationHandlerProvider>(),
                sp.getOrThrow<IAuthorizationHandlerContextFactory>(),
                sp.getOrThrow<IAuthorizationEvaluator>(),
                sp.getOrThrow<IOptions<AuthorizationOptions>>()
            )
        }
        this.tryAddTransient<IAuthorizationPolicyProvider, DefaultAuthorizationPolicyProvider> {
            sp => DefaultAuthorizationPolicyProvider(sp.getOrThrow<IOptions<AuthorizationOptions>>())
        }
        this.tryAddTransient<IAuthorizationHandlerProvider, DefaultAuthorizationHandlerProvider> {
            sp => DefaultAuthorizationHandlerProvider(sp.getAll<IAuthorizationHandler>())
        }
        this.tryAddTransient<IAuthorizationEvaluator, DefaultAuthorizationEvaluator> {
            _ => DefaultAuthorizationEvaluator()
        }
        this.tryAddTransient<IAuthorizationHandlerContextFactory, DefaultAuthorizationHandlerContextFactory> {
            _ => DefaultAuthorizationHandlerContextFactory()
        }
        this.tryAddEnumerable(
            ServiceDescriptor.transient<IAuthorizationHandler, PassThroughAuthorizationHandler> {
                sp => PassThroughAuthorizationHandler(sp.getOrThrow<IOptions<AuthorizationOptions>>())
            })
        return this
    }

    public  func addAuthorization(configure: (AuthorizationOptions) -> Unit): ServiceCollection {
        addAuthorizationCore(configure)
        return this
    }
}
