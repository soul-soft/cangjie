package aspire_identity_tokens

import aspire_identity_claims.*

public interface ISecurityTokenValidator {
    func validateToken(token: String, parameters: TokenValidationParameters): TokenValidationResult
}