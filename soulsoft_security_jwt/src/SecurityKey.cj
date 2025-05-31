package soulsoft_security_jwt

public abstract class SecurityKey {
    private var _keyId: ?String = None
    private var _cryptoProviderFactory = CryptoProviderFactory.default
  
    public prop keySize: Int64

    public mut prop keyId: ?String {
        get() {
            _keyId
        }
        set(value) {
            _keyId = value
        }
    }

    public mut prop cryptoProviderFactory: CryptoProviderFactory {
        get() {
            _cryptoProviderFactory
        }
        set(value) {
            _cryptoProviderFactory = value
        }
    }
}