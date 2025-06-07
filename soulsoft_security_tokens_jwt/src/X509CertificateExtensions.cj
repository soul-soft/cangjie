package soulsoft_security_tokens_jwt
import std.unicode.UnicodeStringExtension

import stdx.crypto.x509.*
import stdx.encoding.hex.*
import stdx.crypto.digest.*

extend X509Certificate{
    /*
    计算证书指纹
    */
    public func getThumbprint() {
        let hasher = SHA1()
        hasher.write(this.encodeToDer().body)
        let hash = hasher.finish()
        return toHexString(hash).toUpper()
    }

    public func getX5t() {
        let hasher = SHA1()
        hasher.write(this.encodeToDer().body)
        let hash = hasher.finish()
        return Base64UrlEncoder.encode(hash)
    }
}