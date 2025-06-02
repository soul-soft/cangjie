package soulsoft_security_jwt

public class JwtSecurityToken {
    private let _header: JwtHeader
    private let _payload: JwtPayload
    
    public init(header: JwtHeader, payload: JwtPayload) {
        _header = header
        _payload = payload
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
