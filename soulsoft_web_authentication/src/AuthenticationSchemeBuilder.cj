package soulsoft_web_authentication

import std.reflect.*

public class AuthenticationSchemeBuilder {
    private let _name: String

    public var displyName: ?String = None
    public var handleType: ?TypeInfo = None

    public init(name: String) {
        _name = name
    }

    public prop name: String {
        get() {
            _name
        }
    }

    public func build() {
        AuthenticationScheme(_name, displyName, handleType.getOrThrow())
    }
}
