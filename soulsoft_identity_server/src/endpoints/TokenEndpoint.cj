package soulsoft_identity_server.endpoints

import soulsoft_asp_http.*
import stdx.serialization.serialization.*
import soulsoft_identity_server.constants.*
import soulsoft_identity_server.hosting.*

public class TokenEndpoint <: EndpointHandler {
    public func handle(context: HttpContext): IEndpointResult {
        if (!HttpMethods.isPost(context.request.method)) {
            return methodNotAllowed()
        }
      
        if (!context.request.hasFormContentType()) {
            return error(InvalidErrors.InvalidRequest, "Content-Type must be application/x-www-form-urlencoded")
        }

        let scope = context.request.form.get(ParameterNames.Scope)

        if (scope.isSome()) {
            return error(InvalidErrors.InvalidScope, "Invalid scope parameter.")
        }    

        
        return methodNotAllowed()
    }
}
