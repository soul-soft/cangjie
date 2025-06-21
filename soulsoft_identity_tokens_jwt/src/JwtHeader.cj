package soulsoft_identity_tokens_jwt

import std.collection.*
import stdx.encoding.json.*
import soulsoft_identity_tokens.*

public class JwtHeader <: JwtContent {
    private let _signingCredentials: SigningCredentials

    public init(signingCredentials: SigningCredentials, outboundAlgorithmMap: Collection<(String, Any)>) {
        _signingCredentials = signingCredentials
        add(all: outboundAlgorithmMap)
        addFirstPriorityClaims()
    }

    public init(signingCredentials: SigningCredentials) {
        this(signingCredentials, [])
    }

    public prop typ: String {
        get() {
            "JWT"
        }
    }

    public prop alg: String {
        get() {
            _signingCredentials.algorithm
        }
    }

    public prop kid: ?String {
        get() {
            _signingCredentials.key.keyId
        }
    }

    private func addFirstPriorityClaims() {
        this["alg"] = alg
        this["typ"] = typ
        if (let Some(kid) <- signingCredentials.key.keyId) {
            this["kid"] = kid
        }
    }

    public prop signingCredentials: SigningCredentials {
        get() {
            _signingCredentials
        }
    }
}
