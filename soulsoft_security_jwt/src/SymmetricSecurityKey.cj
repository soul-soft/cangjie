package soulsoft_security_jwt

public class SymmetricSecurityKey <: SecurityKey {
    private let _key: Array<Byte>
    private var _keyId: ?Int64 = None

    public init(key: Array<Byte>) {
        _key = key
    }

    public prop keySize: Int64 {
        get() {
            _key.size
        }
    }

    public prop key: Array<Byte> {
        get() {
            _key
        }
    }
}