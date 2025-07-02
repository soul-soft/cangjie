package aspire_identity_tokens

import stdx.crypto.keys.*

public struct RsaParameters {

    public RsaParameters(
        public let d!: ?Array<Byte> = None,
        public let dp!: ?Array<Byte> = None,
        public let dq!: ?Array<Byte> = None,
        public let exponent!: ?Array<Byte> = None,
        public let inverseQ!: ?Array<Byte> = None,
        public let modulus!: ?Array<Byte> = None,
        public let p!: ?Array<Byte> = None,
        public let q!: ?Array<Byte> = None) {
    }
    
}
