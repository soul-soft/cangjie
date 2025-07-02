package aspire_net_http

import std.collection.*
import stdx.net.http.HttpHeaders

public class HttpContentHeaders <: Iterable<(String, Collection<String>)> {
    private let _headers = HttpHeaders()

    init() {
    }

    public func iterator() {
        _headers.iterator()
    }

    public func add(name: String, value: String): Unit {
        _headers.add(name, value)
    }

    public func set(name: String, value: String) {
        _headers.set(name, value)
    }

    public func remove(name: String) {
        _headers.del(name)
    }

    public func get(name: String) {
        _headers.get(name)
    }

    public func getFirst(name: String) {
        _headers.getFirst(name)
    }
}
