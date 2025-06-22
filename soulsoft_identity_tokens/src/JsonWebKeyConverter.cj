package soulsoft_identity_tokens

import stdx.crypto.keys.*

public class JsonWebKeyConverter {
   
    public static func convert(key: SymmetricSecurityKey, algorithm!: ?String = None) {
        let jwk = JsonWebKey(key.keyId, key.keySize)
        jwk.k = Base64UrlEncoder.encode(key.key)
        jwk.kty = "oct"
        jwk.use = "sig"
        jwk.alg = algorithm
        return jwk
    }

    public static func convert(key: ECDsaSecurityKey, algorithm!: ?String = None) {
        let jwk = JsonWebKey(key.keyId, key.keySize)
        jwk.kty = "EC"
        jwk.use = "sig"
        jwk.alg = algorithm
        if (let Some(alg) <- algorithm) {
            jwk.crv = CryptoHelper.getCrvParameterValue(alg)
        }
        if (let Some(parameters) <- key.publicKey.flatMap{f => f.exportParameters()}) {
            jwk.x = Base64UrlEncoder.encode(parameters.q.x)
            jwk.y = Base64UrlEncoder.encode(parameters.q.x)
        }
        return jwk
    }

    public static func convert(key: RsaSecurityKey, algorithm!: ?String = None) {
        let jwk = JsonWebKey(key.keyId, key.keySize)
        jwk.kty = "EC"
        jwk.use = "sig"
        jwk.alg = algorithm
        if (let Some(alg) <- algorithm) {
            jwk.crv = CryptoHelper.getCrvParameterValue(alg)
        }
        // if (let Some(parameters) <- key.exportParameters(false)) {
        //     jwk.x = Base64UrlEncoder.encode(parameters.q.x)
        //     jwk.y = Base64UrlEncoder.encode(parameters.q.x)
        // }
        return jwk
    }

    public static func convert(signingCredentials: SigningCredentials) {
        if (let Some(key) <- (signingCredentials.key as SymmetricSecurityKey)) {
            return convert(key, algorithm: signingCredentials.algorithm)
        }
        if (let Some(key) <- (signingCredentials.key as ECDsaSecurityKey)) {
            return convert(key, algorithm: signingCredentials.algorithm)
        }
        if (let Some(key) <- (signingCredentials.key as RsaSecurityKey)) {
            return convert(key, algorithm: signingCredentials.algorithm)
        }
        throw UnsupportedException()
    }
}
