package soulsoft_security_tokens_jwt

import std.fs.*
import std.io.*
import std.time.*
import std.collection.*
import stdx.crypto.digest.*
import stdx.crypto.x509.*
import stdx.crypto.keys.*
import stdx.encoding.hex.*

main(): Int64 {
    let securityKey = SymmetricSecurityKey("SECUZebfRscapBanPymcs5CZEJpEFjSISECUZebfRscapBanPymcs5CZEJpEFjSI".toArray())
    //println(String.fromUtf8(readToEnd(File("ec256-private.pem", OpenMode.Read))))
    //let pem = ECDSAPrivateKey.decodeFromPem(String.fromUtf8(readToEnd(File("ec256-private.pem", OpenMode.Read))))
    //let securityKey = ECDsaSecurityKey(privateKey: pem)
    let header = JwtHeader(SigningCredentials(securityKey, SecurityAlgorithms.HmacSha256))
    let payload = JwtPayload(
        issuer: "soulsoft",
        audience: "cangjie",
        notBefore: DateTime.now(),
        expires: DateTime.now(),
        claims: [("sub", "1024")]
    )
    // payload.add("id", 1)
    // payload.add("id", 2)
    payload.add("iss", "cangjie")
    payload.add("iss", "cangjie")
  
    println(payload.toJsonString())
   
    var jwtToken = JwtSecurityToken(header, payload)
    let tokenHandler = JwtSecurityTokenHandler()
    tokenHandler.writeToken(jwtToken) |> println
    var parameters = TokenValidationParameters(securityKey)
    parameters.validIssuer = "cangjie"
    parameters.validAudience = "cangjie"
    let claims = tokenHandler.validateToken(tokenHandler.writeToken(jwtToken), parameters)
    for (pattern in claims.claims) {
        println("${pattern.name}=${pattern.value}")
    }
    return 0
}
