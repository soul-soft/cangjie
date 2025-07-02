package aspire_identity_server.validation

import aspire_identity_server.models.*

public interface IScopeValidator {
    func Validate(scope: String): Resources
}