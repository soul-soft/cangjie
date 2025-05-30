package soulsoft_asp_authentication

import std.time.*
import std.collection.*

public class AuthenticationProperties {
    private static let _issuedUtcKey = "__issued"
    private static let _expiresUtcKey = "__expires"
    private static let _isPersistentKey = "__persistent"
    private static let _redirectUriKey = "__redirect"
    private static let _refreshKey = "__refresh"

    private let _items = HashMap<String, Any>()

    public init(items: Array<(String, Any)>) {
        _items.add(all: items)
    }

    public prop items: HashMap<String, Any> {
        get() {
            _items
        }
    }

    public mut prop isPersistent: Bool {
        get() {
            getString(_isPersistentKey).isSome()
        }
        set(value) {
            setString(_isPersistentKey, if (value) {
                String.empty
            } else {
                None
            })
        }
    }

    public mut prop redirectUri: ?String {
        get() {
            getString(_redirectUriKey)
        }
        set(value) {
            setString(_redirectUriKey, value)
        }
    }

    public mut prop issuedUtc: ?DateTime {
        get() {
            get(_issuedUtcKey).flatMap {f => f as DateTime}
        }
        set(value) {
            set(_issuedUtcKey, value)
        }
    }

    public mut prop expiresUtc: ?DateTime {
        get() {
            get(_expiresUtcKey).flatMap {f => f as DateTime}
        }
        set(value) {
            set(_expiresUtcKey, value)
        }
    }

    public mut prop allowRefresh: ?Bool {
        get() {
            getBool(_refreshKey)
        }
        set(value) {
            setBool(_refreshKey, value)
        }
    }

    public func get(key: String) {
        _items.get(key)
    }

    public func set(key: String, value: Any) {
        _items[key] = value
    }

    public func getString(key: String) {
        _items.get(key).flatMap {f => f as String}
    }

    public func setString(key: String, value: ?String) {
        _items[key] = value
    }

    public func getBool(key: String) {
        _items.get(key).flatMap {f => f as Bool}
    }

    public func setBool(key: String, value: ?Bool) {
        _items[key] = value
    }
}
