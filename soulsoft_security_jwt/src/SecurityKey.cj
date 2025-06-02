package soulsoft_security_jwt

import stdx.crypto.x509.*
import std.crypto.digest.*

public abstract class SecurityKey {
   public prop keyId: ?String
   public prop keySize: Int64
}
