package aspire_identity_tokens

class CryptoHelper {
    public static func getCrvParameterValue(algorithm: String): ?String {
        if (algorithm == SecurityAlgorithms.RsaSha256 || algorithm == SecurityAlgorithms.EcdsaSha256) {
            return "P-256"
        }
        if (algorithm == SecurityAlgorithms.RsaSha384 || algorithm == SecurityAlgorithms.EcdsaSha384) {
            return "P-384"
        }
        if (algorithm == SecurityAlgorithms.RsaSha512 || algorithm == SecurityAlgorithms.EcdsaSha512) {
            return "P-512"
        }
        return None
    }
}