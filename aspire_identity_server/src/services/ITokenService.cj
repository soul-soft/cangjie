package aspire_identity_server.services

import aspire_identity_server.models.*

public interface ITokenService {
    func create(token: Token): String
}