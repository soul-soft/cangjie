package soulsoft_security_tokens_jwt

import stdx.encoding.url.*
import stdx.encoding.base64.*

public class Base64UrlEncoder {
    public static func encode(input: String) {
        return encode(input.toArray())
    }

    public static func encode(data: Array<Byte>) {
        return toBase64String(data).replace('+', '-').replace('/', '_').trimEnd(r'=')
    }

    public static func decode(data: String): ?Array<Byte> {
        let base64 = data.replace('-', '+').replace('_', '/')
        let remainder = base64.toRuneArray().size % 4
        if (remainder > 0) {
            let endStr = String(Array<Rune>(4 - remainder, repeat: r'='))
            return fromBase64String("${base64}${endStr}")
        }
        return fromBase64String("${base64}")
    }
}
