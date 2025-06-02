package soulsoft_security_jwt

import stdx.encoding.url.*
import stdx.encoding.base64.*

public class Base64UrlEncoder {
    
    public static func encode(input: String) {
        return encode(input.toArray())
    }

    public static func encode(data: Array<Byte>) {
        return toBase64String(data).replace('+', '-').replace('/', '_').trimEnd(r'=')
    }

    public static func decode(data: String) {
        return fromBase64String("${data.replace('-', '+').replace('_', '/')}==")
    }
}
