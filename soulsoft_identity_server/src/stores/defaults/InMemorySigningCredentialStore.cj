package soulsoft_identity_server.stores.defaults

import soulsoft_identity_tokens.*
import soulsoft_identity_server.stores.*

public class InMemorySigningCredentialStore <: ISigningCredentialStore {
  
    public InMemorySigningCredentialStore(
        private let signingCredentials: SigningCredentials) {
    }

    public func getSigningCredentials(): SigningCredentials {
        signingCredentials
    }
}