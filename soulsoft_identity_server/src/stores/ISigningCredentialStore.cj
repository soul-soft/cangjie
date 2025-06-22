package soulsoft_identity_server.stores

import soulsoft_identity_tokens.*

public interface ISigningCredentialStore {
    func getSigningCredentials(): SigningCredentials
}