package aspire_identity_server.hosting

import std.reflect.*
import std.collection.*
import aspire_web_http.*
import aspire_extensions_injection.*
import aspire_identity_server.options.*

public class EndpointRouter <: IEndpointRouter {
    private let _options: IdentityServerOptions
    private let _descriptors: EndpointManager

    public init(options: IdentityServerOptions, descriptors: EndpointManager) {
        _options = options
        _descriptors = descriptors
    }

    public func routing(context: HttpContext): ?IEndpointHandler {
        let path = context.request.path.value
        let descriptor = _descriptors |> filter{f => f.path.equalsIgnoreAsciiCase(path) } |> first
        if (let Some(descriptor) <- descriptor) {
            if (!_options.endpoints.isEnable(descriptor.name)) {
                return None
            }
            return createEndpointHandler(context, descriptor.typeInfo)
        }
        return None
    }

    private func createEndpointHandler(context: HttpContext, typeInfo: TypeInfo) {
        let instance = ActivatorUtilities.createInstance(context.services, typeInfo)
        return (instance as IEndpointHandler).getOrThrow()
    }
}