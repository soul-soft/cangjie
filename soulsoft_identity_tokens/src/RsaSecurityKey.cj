package soulsoft_identity_tokens

import stdx.crypto.x509.*
import stdx.crypto.keys.*

public class RsaSecurityKey <: AsymmetricSecurityKey {
    private let _publicKey: ?RSAPublicKey
    private let _privateKey: ?RSAPrivateKey

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

    // public func exportParameters(includePrivateParameters: Bool): ?ECParameters {
    //     if (let Some(key) <- _publicKey) {
    //         let data = key.encodeToDer().body
    //         let x = data[1..32]
    //         let y = data[33..32]
    //         var d = Option<Array<Byte>>.None
    //         if (includePrivateParameters) {
    //             d = data
    //         }
    //         return ECParameters(ECPoint(x, y), d)
    //     }
    //     return None
    // }
}