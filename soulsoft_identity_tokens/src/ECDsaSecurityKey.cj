package soulsoft_identity_tokens

import std.convert.*
import std.collection.*
import stdx.crypto.keys.*
import stdx.encoding.base64.*

public class ECDsaSecurityKey <: AsymmetricSecurityKey {
    private let _publicKey: ?ECDSAPublicKey
    private let _privateKey: ?ECDSAPrivateKey

    public init(publicKey!: ?ECDSAPublicKey = None, privateKey!: ?ECDSAPrivateKey = None) {
        _publicKey = publicKey
        _privateKey = privateKey
    }

    public prop publicKey: ?ECDSAPublicKey {
        get() {
            _publicKey
        }
    }

    public prop privateKey: ?ECDSAPrivateKey {
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

    public func exportParameters(): ?ECParameters {
        if (let Some(key) <- _publicKey) {
            let body = key.encodeToDer().body
            let parameters = AsnParser.parse(body).toHashMap()
            if (let Some(bitStringData) <- parameters.get("03")) {
                let coordinateSize = (bitStringData.size - 2) / 2
                let x = bitStringData[2..coordinateSize + 2]
                let y = bitStringData[coordinateSize + 2..bitStringData.size]
                return ECParameters(ECPoint(x, y))
            }
        }

        return None
    }
}
