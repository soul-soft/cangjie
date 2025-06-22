package soulsoft_identity_server.services


import soulsoft_identity_tokens.*

public interface IKeyManager {
    func getActiveSigningKeys(): Collection<SigningCredentials>
    func getAllValidationKeys(): Collection<SigningCredentials> {
        []
    }
}
