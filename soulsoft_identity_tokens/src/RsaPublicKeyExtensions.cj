package soulsoft_identity_tokens

import std.convert.*
import std.collection.*
import stdx.crypto.keys.*

public interface RsaPublicKeyExtensions {
    func exportParameters(): ?ECParameters
}

//https://lapo.it/asn1js/#MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEHf5aRF8KivArMYJt4C5JKDxt0Fac_DylQJwu22n0a-SWv0HUs0UY1hae4VFKM0s_IzizODOin7eqqYk2eGhADA
extend RSAPublicKey <: RsaPublicKeyExtensions {
    public func exportParameters(): ?ECParameters {
        let data = this.encodeToDer().body
        var i = 0
        var x = Option<Array<Byte>>.None
        var y = Option<Array<Byte>>.None
        while (i < data.size) {
            if (data[i] == 0x30) {
                i += 2
                continue
            }
            if (data[i] == 0x06) {
                i += Int64(data[i + 1]) + 2
                continue
            }
            if (data[i] == 0x03) {
                let size = Int64(data[i + 1])
                let bitStringData = data[i + 2..i + 2 + size]
                let coordinateLength = (bitStringData.size - 2) / 2
                x = bitStringData[2..coordinateLength + 2]
                y = bitStringData[coordinateLength + 2..bitStringData.size]
                i += Int64(size) + 2
                break
            }
            i += 1
        }
        if (let (Some(x), Some(y)) <- (x, y)) {
            return ECParameters(ECPoint(x, y))
        }
        return None
    }
}
