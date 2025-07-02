package aspire_identity_tokens

import stdx.crypto.x509.*
import std.crypto.digest.*
import stdx.serialization.serialization.*

public abstract class SecurityKey {
   public prop keyId: ?String
   public prop keySize: Int64
}
