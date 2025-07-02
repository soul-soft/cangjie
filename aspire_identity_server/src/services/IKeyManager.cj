package aspire_identity_server.services


import aspire_identity_tokens.*

public interface IKeyManager {
    func getActiveSigningKeys(): Collection<SigningCredentials>
    func getAllValidationKeys(): Collection<SigningCredentials> {
        []
    }
}
