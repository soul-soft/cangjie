package soulsoft_security_jwt

main(): Int64 {
    //eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJqd3QifQ._Waa_P7PfYV7hSNOQbUCdKYIYFOoVfqEZ8FjoYqHP04
    let securityKey = SymmetricSecurityKey("your-256-bit-secret-key-herefaaaaaaaaaaaaaaaa".toArray())
    let signingCredentials = SigningCredentials(securityKey, SecurityAlgorithms.HMAC_SHA_256)
    let header = JwtHeader(signingCredentials)
    let payload = JwtPayload([("sub", "jwt")])
    var jwtToken = JwtSecurityToken(header, payload)
    let tokenHandler = JwtSecurityTokenHandler()
    tokenHandler.writeToken(jwtToken) |> println
    return 0
}
