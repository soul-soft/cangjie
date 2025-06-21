package soulsoft_identity_server.hosting

import std.reflect.*
import soulsoft_extensions_injection.*

public class EndpointFactory <: IEndpointFactory {
    private let _services: IServiceProvider

    public init(services: IServiceProvider) {
        _services = services
    }

    public func create(typeInfo: TypeInfo): IEndpointHandler {
        let instance = ActivatorUtilities.createInstance(_services, typeInfo)
        return (instance as IEndpointHandler).getOrThrow()
    }
}
