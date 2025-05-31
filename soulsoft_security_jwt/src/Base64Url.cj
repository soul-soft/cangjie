package soulsoft_security_jwt

import stdx.encoding.url.*
import stdx.encoding.base64.*

func toBase64UrlString(input: String) {
    return toBase64String(input.toArray()).replace('+', '-').replace('/', '_').trimEnd(r'=')
}

func toBase64UrlString(data: Array<Byte>) {
    return toBase64String(data).replace('+', '-').replace('/', '_').trimEnd(r'=')
}
