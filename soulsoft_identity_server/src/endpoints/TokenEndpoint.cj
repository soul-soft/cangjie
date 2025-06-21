package soulsoft_identity_server.endpoints

import soulsoft_asp_http.*
import stdx.serialization.serialization.*
import soulsoft_identity_protocols_oidc.*
import soulsoft_identity_server.hosting.*
import soulsoft_identity_server.services.*
import soulsoft_identity_server.constants.*

public class TokenEndpoint <: EndpointHandler {
    public func handle(context: HttpContext): IEndpointResult {
        if (!HttpMethods.isPost(context.request.method)) {
            return methodNotAllowed()
        }
        context.services.getOrThrow<IServerUrls>()
        context.services.getOrThrow<IDiscoveryDecumentService>()
        if (!context.request.hasFormContentType()) {
            return error(InvalidErrors.InvalidRequest, "Content-Type must be application/x-www-form-urlencoded")
        }

        let scope = context.request.form.get(OpenIdConnectParameterNames.Scope)

        if (scope.isSome()) {
            return error(InvalidErrors.InvalidScope, "Invalid scope parameter.")
        }    
        
        return methodNotAllowed()
    }
}
