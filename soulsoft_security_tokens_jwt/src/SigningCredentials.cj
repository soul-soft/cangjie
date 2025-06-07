package soulsoft_security_tokens_jwt

import stdx.crypto.x509.*
import stdx.crypto.keys.*

public class SigningCredentials {
    private let _key: SecurityKey
    private let _algorithm: String

    public init(key: SecurityKey, algorithm: String) {
        _key = key
        _algorithm = algorithm
    }

    public prop key: SecurityKey {
        get() {
            _key
        }
    }

    public prop algorithm: String {
        get() {
            _algorithm
        }
    }
}
