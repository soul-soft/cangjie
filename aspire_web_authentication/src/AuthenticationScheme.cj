package aspire_web_authentication

import std.reflect.*

public class AuthenticationScheme {
    private let _name: String
    private let _displayName: ?String
    private let _handlerType: TypeInfo

    public init(name: String, displayName: ?String, handlerType: TypeInfo) {
        _name = name
        _displayName = displayName
        _handlerType = handlerType

        if (!handlerType.isSubtypeOf(TypeInfo.of<IAuthenticationHandler>())) {
            throw IllegalArgumentException("handlerType must be a subtype of IAuthenticationHandler")
        }
    }

    public prop name: String {
        get() {
            _name
        }
    }

    public prop displayName: ?String {
        get() {
            _displayName
        }
    }

    public prop handlerType: TypeInfo {
        get() {
            _handlerType
        }
    }
}
