package aspire_identity_server.stores

import aspire_identity_tokens.*

public interface ISigningCredentialStore {
    func getSigningCredentials(): SigningCredentials
}