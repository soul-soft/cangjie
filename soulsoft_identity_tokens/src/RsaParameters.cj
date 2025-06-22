package soulsoft_identity_tokens

import stdx.crypto.keys.*

public struct RsaParameters {
    public RsaParameters(public let q: ECPoint) {
    }
}
