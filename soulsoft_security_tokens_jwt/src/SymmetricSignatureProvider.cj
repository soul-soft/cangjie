package soulsoft_security_tokens_jwt

import std.reflect.*
import stdx.encoding.hex.*
import stdx.crypto.digest.*

public class SymmetricSignatureProvider <: SignatureProvider {
    public init(key: SecurityKey, algorithm: String) {
        super(key, algorithm)
    }

    public func sign(input: Array<Byte>): Array<Byte> {
        let hmac = createHmacInstance()
        hmac.write(input)
        return hmac.finish()
    }

    public func verify(input: Array<Byte>, signature: Array<Byte>): Bool {
        return sign(input) == signature
    }

    private func createHmacInstance() {
        if (let symmetricSecurityKey: SymmetricSecurityKey <- this.key) {
            if (algorithm == SecurityAlgorithms.HmacSha256) {
                return HMAC(symmetricSecurityKey.key, HashType.SHA256)
            }
            if (algorithm == SecurityAlgorithms.HmacSha384) {
                return HMAC(symmetricSecurityKey.key, HashType.SHA384)
            }
            if (algorithm == SecurityAlgorithms.HmacSha512) {
                return HMAC(symmetricSecurityKey.key, HashType.SHA512)
            }
        }
        throw UnsupportedException()
    }
}
