package aspire_identity_server.endpoints

import aspire_web_http.*
import aspire_identity_server.models.*
import stdx.serialization.serialization.*
import aspire_identity_protocols_oidc.*
import aspire_identity_server.hosting.*
import aspire_identity_server.services.*
import aspire_identity_server.constants.*

public class TokenEndpoint <: EndpointHandler {
    public TokenEndpoint(let tokens: ITokenService) {
        
    }
    public func handle(context: HttpContext): IEndpointResult {
        if (!HttpMethods.isPost(context.request.method)) {
            return methodNotAllowed()
        }
     
        if (!context.request.hasFormContentType()) {
            return error(InvalidErrors.InvalidRequest, "Content-Type must be application/x-www-form-urlencoded")
        }

        // let scope = context.request.form.get(OpenIdConnectParameterNames.Scope)

        // if (scope.isSome()) {
        //     return error(InvalidErrors.InvalidScope, "Invalid scope parameter.")
        // }    
        let accessToken = tokens.create(Token())
        return json(TokenResult(accessToken, 3600))
    }
}


class TokenResult <: Serializable<TokenResult> {
    public TokenResult(let accessToken: String, let expiresIn: Int64) {
        
    }

    public func serialize(): DataModel {
        var dms = DataModelStruct()
        dms.add(Field(OpenIdConnectParameterNames.ExpiresIn, expiresIn.serialize()))
        dms.add(Field(OpenIdConnectParameterNames.AccessToken, accessToken.serialize()))
        return dms
    }

    public static func deserialize(_: DataModel): TokenResult {
        throw UnsupportedException()
    }
}