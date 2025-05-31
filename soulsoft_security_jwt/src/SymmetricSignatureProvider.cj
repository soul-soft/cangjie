package soulsoft_security_jwt

import stdx.crypto.digest.*

public class SymmetricSignatureProvider <: SignatureProvider {
    public init(key: SecurityKey, algorithm: String) {
        super(key, algorithm)
    }

    public func sign(input: Array<Byte>) {
        let hasher = key.cryptoProviderFactory.CreateHashAlgorithm(getKeyBytes(), algorithm)
        hasher.write(input)
        return hasher.finish()
    }

    public func verify(input: Array<Byte>, signature: Array<Byte>): Bool {
        return false
    }

    private func getKeyBytes() {
        if (let symmetricSecurityKey: SymmetricSecurityKey <- key) {
            return symmetricSecurityKey.key
        }
        throw UnsupportedException()
    }
}
