package soulsoft_identity_tokens

import stdx.serialization.serialization.*

public class JsonWebKey <: SecurityKey {
    private let _keyId: ?String
    private let _keySize: Int64

    public init(keyId: ?String, keySize: Int64) {
        _keyId = keyId
        _keySize = keySize
    }

    public var k = Option<String>.None
    public var d = Option<String>.None
    public var x = Option<String>.None
    public var y = Option<String>.None
    public var crv = Option<String>.None
    public var kty = Option<String>.None
    public var use = Option<String>.None
    public var alg = Option<String>.None

    public prop kid: ?String {
        get() {
            keyId
        }
    }

    public prop keyId: ?String {
        get() {
            _keyId
        }
    }

    public prop keySize: Int64 {
        get() {
            _keySize
        }
    }

    public func serialize(): DataModel {
        let dms = DataModelStruct()
        //dms.add(Field("k", k.))
        return dms
    }
}
