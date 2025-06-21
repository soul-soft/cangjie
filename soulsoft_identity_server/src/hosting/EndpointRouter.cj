package soulsoft_identity_server.hosting

import std.collection.*
import soulsoft_asp_http.*
import soulsoft_identity_server.options.*

public class EndpointRouter <: IEndpointRouter {
    private let _factory: IEndpointFactory
    private let _options: IdentityServerOptions
    private let _descriptors: Collection<EndpointDescriptor>

    public init(factory: IEndpointFactory, options: IdentityServerOptions, descriptors: Collection<EndpointDescriptor>) {
        _factory = factory
        _options = options
        _descriptors = descriptors
    }

    public func routing(context: HttpContext): ?IEndpointHandler {
        let descriptor = _descriptors |> filter{f => context.request.path == "${_options.endpointPrefix}/${f.path}"} |> first
        if (let Some(descriptor) <- descriptor) {
            return _factory.create(descriptor.typeInfo)
        }
        return None
    }
}