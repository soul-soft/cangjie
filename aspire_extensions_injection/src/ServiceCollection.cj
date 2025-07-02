package aspire_extensions_injection

import std.reflect.*
import std.collection.*
import std.collection.last as Last

public class ServiceCollection <: List<ServiceDescriptor> {
    private var _isReadOnly = false
    private let _items = ArrayList<ServiceDescriptor>()

    public func add(element: ServiceDescriptor) {
        onChange()
        _items.add(element)
    }

    public func tryAdd(element: ServiceDescriptor) {
        onChange()
        if (_items |> any {a => a.serviceType == element.serviceType}) {
            return
        }
        _items.add(element)
    }

    public func add(all!: Collection<ServiceDescriptor>) {
        onChange()
        _items.add(all: all)
    }

    public func add(element: ServiceDescriptor, at!: Int64) {
        onChange()
        _items.add(element, at: at)
    }

    public func add(all!: Collection<ServiceDescriptor>, at!: Int64) {
        onChange()
        _items.add(all: all, at: at)
    }

    public func remove(at!: Int64) {
        onChange()
        _items.remove(at: at)
    }

    public func remove(range: Range<Int64>) {
        onChange()
        _items.remove(range)
    }

    public func removeIf(predicate: (ServiceDescriptor) -> Bool) {
        onChange()
        _items.removeIf(predicate)
    }

    public func isEmpty() {
        _items.isEmpty()
    }

    public func clear() {
        onChange()
        _items.clear()
    }

    public func get(index: Int64) {
        _items.get(index)
    }

    public prop first: ?ServiceDescriptor {
        get() {
            _items.first
        }
    }

    public prop last: ?ServiceDescriptor {
        get() {
            _items.first
        }
    }

    public prop size: Int64 {
        get() {
            _items.size
        }
    }

    public func toArray() {
        _items.toArray()
    }

    public func iterator() {
        _items.iterator()
    }

    public operator func [](index: Int64): ServiceDescriptor {
        _items[index]
    }

    public operator func [](index: Int64, value!: ServiceDescriptor) {
        onChange()
        _items[index] = value
    }

    public func findLast(serviceType: TypeInfo) {
        _items |> filter {f => f.serviceType == serviceType} |> Last
    }

    public func findAll(serviceType: TypeInfo) {
        _items |> filter {f => f.serviceType == serviceType} |> collectArray
    }

    public func build(): IServiceProvider {
        build({_ =>})
    }

    public func build(configureOptions: (ServiceProviderOptions) -> Unit): IServiceProvider {
        let options = ServiceProviderOptions()
        configureOptions(options)
        this._isReadOnly = true
        return ServiceProvider(this, options)
    }

    private func onChange() {
        if (_isReadOnly) {
            throw Exception("The service collection cannot be modified because it is read-only.")
        }
    }
}
