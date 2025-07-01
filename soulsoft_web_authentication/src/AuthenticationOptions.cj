package soulsoft_web_authentication

import std.collection.*

public class AuthenticationOptions {
    private let _schemes = ArrayList<AuthenticationScheme>()
    private let _schemeMap = HashSet<String>()

    public var defaultScheme: ?String = None
    public var defaultAuthenticateScheme: ?String = None
    public var defaultForbidScheme: ?String = None
    public var defaultChallengeScheme: ?String = None

    public prop schemes: ReadOnlyList<AuthenticationScheme> {
        get() {
            return _schemes
        }
    }

    public prop schemeMap: ReadOnlySet<String> {
        get() {
            _schemeMap
        }
    }


    public func addScheme(name: String, configureBuilder: (AuthenticationSchemeBuilder) -> Unit): Unit {
        if (_schemeMap.contains(name)) {
            throw IllegalArgumentException("Scheme already exists: " + name)
        }
        var builder = AuthenticationSchemeBuilder(name)
        configureBuilder(builder)
        _schemes.add(builder.build())
        _schemeMap.add(name)
    }
}
