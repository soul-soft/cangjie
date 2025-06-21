package soulsoft_identity_tokens

public class SymmetricSecurityKey <: SecurityKey {
    private let _key: Array<Byte>

    public init(key: Array<Byte>) {
        _key = key
    }

    public prop key: Array<Byte> {
        get() {
            _key
        }
    }

    public prop keyId: ?String {
        get() {
            None
        }
    }

    public prop keySize: Int64 {
        get() {
            _key.size
        }
    }
}
