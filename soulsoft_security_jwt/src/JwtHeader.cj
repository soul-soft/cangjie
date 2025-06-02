package soulsoft_security_jwt

import std.collection.*
import stdx.encoding.json.*

public class JwtHeader <: Map<String, Any> {
    private let _items: HashMap<String, Any>
    private let _signingCredentials: SigningCredentials

    public init(signingCredentials: SigningCredentials, outboundAlgorithmMap: Collection<(String, Any)>) {
        _signingCredentials = signingCredentials
        _items = HashMap<String, Any>(outboundAlgorithmMap)
        _items.add("alg", alg)
        _items.add("typ", typ)
        if (let Some(kid) <- signingCredentials.key.keyId) {
            _items.add("kid", kid)
        }
    }

    public init(signingCredentials: SigningCredentials) {
        this(signingCredentials, [])
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

    public prop typ: String {
        get() {
            "JWT"
        }
    }

    public prop alg: String {
        get() {
            _signingCredentials.algorithm
        }
    }

    public prop kid: ?String {
        get() {
            _signingCredentials.key.keyId
        }
    }

    public prop signingCredentials: SigningCredentials {
        get() {
            _signingCredentials
        }
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
