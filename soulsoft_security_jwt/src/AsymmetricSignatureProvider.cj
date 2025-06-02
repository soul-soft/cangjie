package soulsoft_security_jwt

import std.reflect.*
import std.crypto.digest.*
import stdx.encoding.hex.*
import stdx.crypto.digest.*

public class AsymmetricSignatureProvider <: SignatureProvider {
    public init(key: SecurityKey, algorithm: String) {
        super(key, algorithm)
    }

    public func sign(input: Array<Byte>): Array<Byte> {
        //ecd-sa
        if (algorithm == SecurityAlgorithms.EcdsaSha256) {
            let privateKey = getECDsaPrivateKey()
            let sha = SHA256()
            return privateKey.sign(digest(sha, input))
        }
        if (algorithm == SecurityAlgorithms.EcdsaSha384) {
            let privateKey = getECDsaPrivateKey()
            let sha = SHA384()
            return privateKey.sign(digest(sha, input))
        }
        if (algorithm == SecurityAlgorithms.EcdsaSha512) {
            let privateKey = getECDsaPrivateKey()
            let sha = SHA512()
            return privateKey.sign(digest(sha, input))
        }
        //rsa
        if (algorithm == SecurityAlgorithms.RsaSha256) {
            let privateKey = getRsaPrivateKey()
            let sha = SHA256()
            return privateKey.sign(sha, digest(sha, input), padType: PKCS1)
        }
        if (algorithm == SecurityAlgorithms.RsaSha384) {
            let privateKey = getRsaPrivateKey()
            let sha = SHA384()
            return privateKey.sign(sha, digest(sha, input), padType: PKCS1)
        }
        if (algorithm == SecurityAlgorithms.RsaSha512) {
            let privateKey = getRsaPrivateKey()
            let sha = SHA512()
            return privateKey.sign(sha, digest(sha, input), padType: PKCS1)
        }
        throw UnsupportedException(algorithm)
    }

    public func verify(input: Array<Byte>, signature: Array<Byte>): Bool {
        return sign(input) == signature
    }

    public func getECDsaPrivateKey() {
        if (let securityKey: ECDsaSecurityKey <- key) {
            return securityKey.privateKey.getOrThrow()
        }
        throw UnsupportedException()
    }

    public func getRsaPrivateKey() {
        if (let securityKey: RsaSecurityKey <- key) {
            return securityKey.privateKey.getOrThrow()
        }
        throw UnsupportedException()
    }
}
