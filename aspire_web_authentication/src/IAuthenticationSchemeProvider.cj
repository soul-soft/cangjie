package aspire_web_authentication

import std.collection.*
import aspire_extensions_options.*

public interface IAuthenticationSchemeProvider {
    func getDefaultScheme(): ?AuthenticationScheme
    func getScheme(name: String): ?AuthenticationScheme
    func getDefaultAuthenticateScheme(): ?AuthenticationScheme
    func getDefaultChallengeScheme(): ?AuthenticationScheme
    func getDefaultForbidScheme(): ?AuthenticationScheme
}

class AuthenticationSchemeProvider <: IAuthenticationSchemeProvider {
    private let _options: AuthenticationOptions
    private let _schemes = HashMap<String, AuthenticationScheme>()

    public init(options: IOptions<AuthenticationOptions>) {
        _options = options.value
        for (pattern in _options.schemes) {
            _schemes.add(pattern.name, pattern)
        }
    }

    public func getScheme(name: String): ?AuthenticationScheme {
        if (_schemes.contains(name)) {
            return _schemes[name]
        }
        return None
    }

    public func getDefaultScheme(): ?AuthenticationScheme {
        if (let Some(name) <- _options.defaultScheme) {
            return getScheme(name)
        }
        return None
    }

    public func getDefaultAuthenticateScheme(): ?AuthenticationScheme {
        if (let Some(name) <- _options.defaultAuthenticateScheme) {
            return getScheme(name)
        }
        return getDefaultScheme()
    }

    public func getDefaultChallengeScheme(): ?AuthenticationScheme {
        if (let Some(name) <- _options.defaultChallengeScheme) {
            return getScheme(name)
        }
        return getDefaultScheme()
    }

    public func getDefaultForbidScheme(): ?AuthenticationScheme {
        if (let Some(name) <- _options.defaultForbidScheme) {
            return getScheme(name)
        }
        return getDefaultScheme()
    }
}
