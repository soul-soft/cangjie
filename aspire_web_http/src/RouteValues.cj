package aspire_web_http

import std.collection.*

public class RouteValues <: Map<String, String> {
    private let _items: HashMap<String, String>

    public init() {
        _items = HashMap<String, String>()
    }

    public init(items: Collection<(String, String)>) {
        _items = HashMap<String, String>(items)
    }

    public operator func [](key: String) {
        _items[key]
    }

    public operator func [](key: String, value!: String) {
        _items[key] = value
    }

    public func contains(key: String) {
        return _items.contains(key)
    }

    public func contains(all!: Collection<String>) {
        return _items.contains(all: all)
    }

    public func get(key: String) {
        return _items.get(key)
    }

    public func isEmpty() {
        _items.isEmpty()
    }

    public func iterator() {
        _items.iterator()
    }

    public func keys() {
        _items.keys()
    }

    public func values() {
        _items.values()
    }

    public func clear() {
        _items.clear()
    }

    public prop size: Int64 {
        get() {
            _items.size
        }
    }

    public func add(key: String, value: String) {
        _items.add(key, value)
    }

    public func add(all!: Collection<(String, String)>) {
        _items.add(all: all)
    }

    public func remove(key: String) {
        _items.remove(key)
    }

    public func remove(all!: Collection<String>) {
        _items.remove(all: all)
    }

    public func removeIf(predicate: (String, String) -> Bool) {
        _items.removeIf(predicate)
    }

    public func entryView(key: String) {
        _items.entryView(key)
    }
}
