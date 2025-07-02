package aspire_identity_tokens

import stdx.crypto.keys.*

public struct ECParameters {
    public ECParameters(public let q: ECPoint) {
    }
}

public struct ECPoint {
    public ECPoint(
        public let x: Array<Byte>,
        public let y: Array<Byte>) {
    }
}
