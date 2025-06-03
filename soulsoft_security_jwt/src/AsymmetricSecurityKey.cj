package soulsoft_security_jwt

import stdx.crypto.x509.*
import stdx.crypto.keys.*

public abstract class AsymmetricSecurityKey <: SecurityKey {}

public class X509SecurityKey <: AsymmetricSecurityKey {
    private let _x5t: String
    private let _keyId: ?String
    private let _keySize: Int64
    private let _certificate: X509Certificate

    public init(certificate: X509Certificate, keyId: String) {
        _keyId = keyId
        _x5t = certificate.getX5t()
        _certificate = certificate
        _keySize = certificate.publicKey.encodeToDer().size
    }

    public init(certificate: X509Certificate) {
        this(certificate, certificate.getThumbprint())
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
}

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
}

public class RsaSecurityKey <: AsymmetricSecurityKey {
    private let _publickey: ?RSAPublicKey
    private let _privateKey: ?RSAPrivateKey

    public init(publickey!: ?RSAPublicKey = None, privateKey!: ?RSAPrivateKey = None) {
        _publickey = publickey
        _privateKey = privateKey
    }

    public prop publickey: ?RSAPublicKey {
        get() {
            _publickey
        }
    }

    public prop privateKey: ?RSAPrivateKey {
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
}
