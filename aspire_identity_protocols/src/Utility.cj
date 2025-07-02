package aspire_identity_protocols
import std.unicode.UnicodeStringExtension

class Utility {
    public static func isHttps(address: String) {
        return address.toLower().startsWith("https")
    }
}