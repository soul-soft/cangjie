package soulsoft_identity_tokens

import stdx.crypto.x509.*

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
