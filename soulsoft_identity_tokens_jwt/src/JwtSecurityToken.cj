package soulsoft_identity_tokens_jwt

import std.time.*
import soulsoft_security_claims.*
import soulsoft_identity_tokens.*

public class JwtSecurityToken <: SecurityToken {
    private let _header: JwtHeader
    private let _payload: JwtPayload

    public init(header: JwtHeader, payload: JwtPayload) {
        _header = header
        _payload = payload
    }

    public init(signingCredentials: SigningCredentials, issuer!: ?String = None, audience!: ?String = None,notBefore!: ?DateTime = None, expires!: ?DateTime = None, issuedAt!: ?DateTime = None, claims!: ?Collection<Claim> = None) {
        this(JwtHeader(signingCredentials), JwtPayload(issuer: issuer, audience: audience, notBefore: notBefore, expires: expires, issuedAt: issuedAt, claims: claims))
    }

    public init(signingCredentials: SigningCredentials, issuer!: ?String = None, audience!: ?String = None,notBefore!: ?DateTime = None, expires!: ?DateTime = None, issuedAt!: ?DateTime = None, claims!: ?Collection<(String, Any)> = None) {
        this(JwtHeader(signingCredentials), JwtPayload(issuer: issuer, audience: audience, notBefore: notBefore, expires: expires, issuedAt: issuedAt, claims: claims))
    }

    public prop id: ?String {
        get() {
            _header.get(ClaimNames.JwtId).flatMap{f => f as String}
        }
    }

    public prop issuer: ?String {
        get() {
            _header.get(ClaimNames.Issuer).flatMap{f => f as String}
        }
    }

    public prop signingKey: SecurityKey {
        get() {
            _header.signingCredentials.key
        }
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
