package soulsoft_security_jwt

import std.fs.*
import std.io.*
import stdx.crypto.digest.*
import stdx.crypto.x509.*
import stdx.crypto.keys.*
import stdx.encoding.hex.*

main(): Int64 {
    //eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJqd3QifQ.rcoEDEasv0zqJlVEfV3PyVCYVIM2rw0YlvH_pKpB3PhOjTyiEHFnzaMi5hOq6u53AOmklmtvOWjvRaB-NNBZnw
    //eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJqd3QifQ._Waa_P7PfYV7hSNOQbUCdKYIYFOoVfqEZ8FjoYqHP04
    //let securityKey = SymmetricSecurityKey("your-256-bit-secret-key-herefaaaaaaaaaaaaaaaa".toArray())
    println(String.fromUtf8(readToEnd(File("ec256-private.pem", OpenMode.Read))))
    let pem = ECDSAPrivateKey.decodeFromPem(String.fromUtf8(readToEnd(File("ec256-private.pem", OpenMode.Read))))
    let securityKey = ECDsaSecurityKey(privateKey: pem)
    let header = JwtHeader(SigningCredentials(securityKey, SecurityAlgorithms.EcdsaSha256))
    let payload = JwtPayload([("sub", "jwt")])
    var jwtToken = JwtSecurityToken(header, payload)
    let tokenHandler = JwtSecurityTokenHandler()
    tokenHandler.writeToken(jwtToken) |> println

    // let pem = String.fromUtf8(File.readFrom("certificate.crt"))
    // let certificates = X509Certificate.decodeFromPem(pem)
    // certificates[0].getX5t() |> println
    return 0
}
