package soulsoft_identity_server.hosting

import std.reflect.*
import std.collection.*
import soulsoft_asp_http.*
import soulsoft_extensions_injection.*
import soulsoft_identity_server.options.*

public class EndpointRouter <: IEndpointRouter {
    private let _options: IdentityServerOptions
    private let _descriptors: EndpointDescriptors

    public init(options: IdentityServerOptions, descriptors: EndpointDescriptors) {
        _options = options
        _descriptors = descriptors
    }

    public func routing(context: HttpContext): ?IEndpointHandler {
        let path = context.request.path.value
        let descriptor = _descriptors.items |> filter{f => f.path.equalsIgnoreAsciiCase(path) } |> first
        if (let Some(descriptor) <- descriptor) {
            return createEndpointHandler(context, descriptor.typeInfo)
        }
        return None
    }

    private func createEndpointHandler(context: HttpContext, typeInfo: TypeInfo) {
        let instance = ActivatorUtilities.createInstance(context.services, typeInfo)
        return (instance as IEndpointHandler).getOrThrow()
    }
}