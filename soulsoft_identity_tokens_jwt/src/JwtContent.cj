package soulsoft_identity_tokens_jwt

import std.time.*
import std.convert.*
import std.collection.*
import stdx.encoding.json.*
import soulsoft_identity_claims.*
import soulsoft_identity_tokens.*

public abstract class JwtContent <: Map<String, Any> {
    private let _items = HashMap<String, Any>()

    public operator func [](name: String) {
        _items[name]
    }

    public operator func [](name: String, value!: Any) {
        _items[name] = value
    }

    public func add(name: String, value: Any) {
        if (_items.contains(name)) {
            if (let list: ArrayList<Any> <- _items[name]) {
                list.add(value)
            } else {
                let list = ArrayList<Any>()
                list.add(_items[name])
                list.add(value)
                _items.add(name, list)
            }
        } else {
            _items.add(name, value)
        }
    }

    public func add(all!: Collection<(String, Any)>) {
        for ((key, value) in all) {
            add(key, value)
        }
    }

    public func clear() {
        _items.clear()
    }

    public func contains(name: String) {
        _items.contains(name)
    }

    public func contains(all!: Collection<String>) {
        _items.contains(all: all)
    }

    public func entryView(name: String) {
        _items.entryView(name)
    }

    public func get(name: String) {
        _items.get(name)
    }

    public func isEmpty() {
        _items.isEmpty()
    }

    public func iterator() {
        _items.iterator()
    }

    public func remove(name: String) {
        _items.remove(name)
    }

    public func remove(all!: Collection<String>) {
        _items.remove(all: all)
    }

    public func removeIf(predicate: (String, Any) -> Bool) {
        _items.removeIf(predicate)
    }

    public func keys() {
        _items.keys()
    }

    public prop size: Int64 {
        get() {
            _items.size
        }
    }

    public func values() {
        _items.values()
    }

    public func toJsonString(): String {
        return JwtJsonSerializer.serialize(this._items)
    }

    public func toBase64UrlString() {
        toJsonString() |> Base64UrlEncoder.encode
    }

    public func toClaims() {
        let claims = ArrayList<Claim>()
        for ((key, value) in this) {
            if (let list: ArrayList<Any> <- value) {
                for (pattern in list) {
                    if (let Some(claim) <- toClaim(key, pattern)) {
                        claims.add(claim)
                    }
                }
            } else {
                if (let Some(claim) <- toClaim(key, value)) {
                    claims.add(claim)
                }
            }
        }
        return claims
    }

    private static func toClaim(name: String, value: Any): ?Claim {
        if (let data: String <- value) {
            return Claim(name, data.toString(), ClaimValueTypes.String)
        } else if (let data: Int64 <- value) {
            return Claim(name, data.toString(), ClaimValueTypes.String)
        } else if (let data: Bool <- value) {
            return Claim(name, data.toString(), ClaimValueTypes.String)
        }
        return None
    }
}
