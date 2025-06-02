package soulsoft_security_jwt

import std.time.*
import std.convert.*
import std.collection.*
import stdx.encoding.json.*
import soulsoft_security_claims.*

public class JwtPayload <: Map<String, Any> {
    private let _items: HashMap<String, Any>

    init(json: String) {
        _items = JsonConverter().toHashMap(json)
    }

    public init(all: Collection<(String, Any)>) {
        _items = HashMap<String, Any>(all)
    }

    public operator func [](name: String) {
        _items[name]
    }

    public operator func [](name: String, value!: Any) {
        _items[name] = value
    }

    public func add(name: String, value: Any) {
        _items.add(name, value)
    }

    public func add(all!: Collection<(String, Any)>) {
        _items.add(all: all)
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

    public func values() {
        _items.values()
    }

    public prop size: Int64 {
        get() {
            _items.size
        }
    }

    public func addClaim(claim: Claim) {
        if (claim.valueType == ClaimValueTypes.Integer) {
            _items.add(claim.name, Int64.parse(claim.value))
        } else if (claim.valueType == ClaimValueTypes.Boolean) {
            _items.add(claim.name, Bool.parse(claim.value))
        } else if (claim.valueType == ClaimValueTypes.Date) {
            _items.add(claim.name, DateTime.parse(claim.value, "yyyy-MM-dd HH:mm:ss"))
        } else if (claim.valueType == ClaimValueTypes.DateTime) {
            _items.add(claim.name, DateTime.parse(claim.value))
        } else {
            _items.add(claim.name, claim.value)
        }
    }

    public func claims() {
        let claims = ArrayList<Claim>()

        for ((key, value) in _items) {
            if (let v: ToString <- value) {
                claims.add(Claim(key, v.toString(), ClaimValueTypes.String))
            } else if (let v: Int64 <- value) {
                claims.add(Claim(key, v.toString(), ClaimValueTypes.Integer))
            } else if (let v: Bool <- value) {
                claims.add(Claim(key, v.toString(), ClaimValueTypes.Boolean))
            } else if (let v: DateTime <- value) {
                claims.add(Claim(key, v.toString(), ClaimValueTypes.Boolean))
            }
        }

        return claims
    }

    public func toJsonString(): String {
        let jsonValue = JsonObject()
        for ((key, value) in _items) {
            if (let str: String <- value) {
                jsonValue.put(key, JsonString(str))
            }
            if (let str: Int64 <- value) {
                jsonValue.put(key, JsonFloat(str))
            }
        }
        return jsonValue.toJsonString()
    }

    public func toBase64UrlString() {
        toJsonString() |> Base64UrlEncoder.encode
    }
}
