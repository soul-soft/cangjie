package aspire_identity_server.stores.defaults

import aspire_identity_tokens.*
import aspire_identity_server.stores.*

public class InMemorySigningCredentialStore <: ISigningCredentialStore {
  
    public InMemorySigningCredentialStore(
        private let signingCredentials: SigningCredentials) {
    }

    public func getSigningCredentials(): SigningCredentials {
        signingCredentials
    }
}