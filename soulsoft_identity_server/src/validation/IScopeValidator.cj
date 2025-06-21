package soulsoft_identity_server.validation

import soulsoft_identity_server.models.*

public interface IScopeValidator {
    func Validate(scope: String): Resources
}