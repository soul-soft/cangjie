package aspire_identity_server.services.defaults

import std.time.*
import std.collection.*
import aspire_identity_tokens_jwt.*
import aspire_identity_server.models.*
import aspire_identity_server.services.*

public class TokenService <: ITokenService {
    public TokenService(let keys: IKeyManager) {
    }

    public func create(_: Token): String {
        let signingCredentials = keys.getActiveSigningKeys() |> first
        let handler = JwtSecurityTokenHandler()
        let claims: Collection<(String, Any)> = [("issuer", "aspire"), ("scope", "api")]
        let jwtToken = JwtSecurityToken(signingCredentials.getOrThrow(), notBefore: DateTime.now(),
            expires: DateTime.now().addDays(1), claims: claims)
        return handler.writeToken(jwtToken)
    }
}
