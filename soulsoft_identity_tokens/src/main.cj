package soulsoft_identity_tokens

import std.io.*
import std.fs.*
import stdx.crypto.keys.*
import stdx.encoding.base64.*

main() {
    let pem = ECDSAPublicKey.decodeFromPem(String.fromUtf8(readToEnd(File("es384-public.pem", OpenMode.Read))))
    // let key = ECDsaSecurityKey(publicKey: pem)
    // pem.exportParameters()
    let bytes = fromBase64String("MHYwEAYHKoZIzj0CAQYFK4EEACIDYgAEt4rGTNW7+TEul7Uv4Ws6qrppc4wGDJMxwKqvW0uAMEDUhKoC0gJDgJMzM05MnCfQQSAYFGLnNOqWdu6etRrxOLL2e8P5ZlKJowv+HstzubyloLdDTVtEcP3BuTTBS6jE")

    if(let Some(bytes) <- bytes) {
        let node = Asn1.parse(bytes)
        node.print()
    }

    return 0
}
