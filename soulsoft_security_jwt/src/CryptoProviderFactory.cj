package soulsoft_security_jwt

import std.crypto.digest.*
import stdx.crypto.digest.*

public class CryptoProviderFactory {
    private static let _default = CryptoProviderFactory()

    public func CreateHashAlgorithm(key: Array<Byte>, algorithm: String): Digest {
        if (algorithm == SecurityAlgorithms.HMAC_SHA_256) {
            return HMAC(key, HashType.SHA256)
        }
        if (algorithm == SecurityAlgorithms.HMAC_SHA_384) {
            return HMAC(key, HashType.SHA384)
        }
        if (algorithm == SecurityAlgorithms.HMAC_SHA_512) {
            return HMAC(key, HashType.SHA512)
        }
        throw UnsupportedException()
    }

    public static prop default: CryptoProviderFactory {
        get() {
            _default
        }
    }
}
