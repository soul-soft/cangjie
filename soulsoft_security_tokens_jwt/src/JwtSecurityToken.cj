package soulsoft_security_tokens_jwt

import std.time.*

public class JwtSecurityToken {
    private let _header: JwtHeader
    private let _payload: JwtPayload

    public init(header: JwtHeader, payload: JwtPayload) {
        _header = header
        _payload = payload
    }

    public init(signingCredentials: SigningCredentials, issuer!: ?String = None, audience!: ?String = None,
        notBefore!: ?DateTime = None, expires!: ?DateTime = None, issuedAt!: ?DateTime = None,
        claims!: Array<(String, Any)>) {
        this(JwtHeader(signingCredentials),
            JwtPayload(issuer: issuer, audience: audience, notBefore: notBefore, expires: expires, issuedAt: issuedAt,
                claims: claims))
    }

    public prop header: JwtHeader {
        get() {
            _header
        }
    }

    public prop payload: JwtPayload {
        get() {
            _payload
        }
    }
}
