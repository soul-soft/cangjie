package soulsoft_security_jwt

public abstract class SignatureProvider {
    private let _key: SecurityKey
    private let _algorithm: String

    protected init(key: SecurityKey, algorithm: String) {
        _key = key
        _algorithm = algorithm
    }

    public prop key: SecurityKey {
        get() {
            _key
        }
    }

    public prop algorithm: String {
        get() {
            _algorithm
        }
    }
    
    public func sign(input: Array<Byte>): Array<Byte>
    
    public func verify(input: Array<Byte>,signature: Array<Byte>): Bool
}
