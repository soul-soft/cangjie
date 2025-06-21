package soulsoft_identity_tokens

import soulsoft_security_claims.*

public interface ISecurityTokenValidator {
    func validateToken(token: String, parameters: TokenValidationParameters): TokenValidationResult
}