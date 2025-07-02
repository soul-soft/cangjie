package aspire_identity_tokens

import std.io.*
import std.fs.*
import stdx.crypto.x509.*
import stdx.crypto.keys.*

public class RsaSecurityKey <: AsymmetricSecurityKey {
    private var _publicKey: ?RSAPublicKey = None
    private var _privateKey: ?RSAPrivateKey = None

    public init(publicKey!: ?RSAPublicKey = None, privateKey!: ?RSAPrivateKey = None) {
        _publicKey = publicKey
        _privateKey = privateKey
    }

    public prop publicKey: ?RSAPublicKey {
        get() {
            _publicKey
        }
    }

    public prop privateKey: ?RSAPrivateKey {
        get() {
            _privateKey
        }
    }

    public prop keySize: Int64 {
        get() {
            0
        }
    }

    public prop keyId: ?String {
        get() {
            None
        }
    }

    public func exportParameters(): ?RsaParameters {
        if (let Some(key) <- _publicKey) {
            let data = key.encodeToDer().body
            let node = AsnParser.parse(data).toHashMap()
            let modulus = node["00:03:1:30:02:0"][1..]
            let exponent = node["00:03:1:30:02:1"]
            return RsaParameters(modulus: modulus, exponent: exponent)
        }
        return None
    }
}