package soulsoft_identity_server.services.defaults

import std.time.*
import std.collection.*
import soulsoft_identity_tokens_jwt.*
import soulsoft_identity_server.models.*
import soulsoft_identity_server.services.*

public class TokenService <: ITokenService {
    public TokenService(let keys: IKeyManager) {
    }

    public func create(token: Token): String {
        let signingCredentials = keys.getActiveSigningKeys() |> first
        let handler = JwtSecurityTokenHandler()
        let claims: Collection<(String, Any)> = [("issuer", "soulsoft"), ("scope", "api")]
        let jwtToken = JwtSecurityToken(signingCredentials.getOrThrow(), notBefore: DateTime.now(),
            expires: DateTime.now().addDays(1), claims: claims)
        return handler.writeToken(jwtToken)
    }
}
