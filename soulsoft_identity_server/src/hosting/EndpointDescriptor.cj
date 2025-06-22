package soulsoft_identity_server.hosting

import std.reflect.*

public class EndpointDescriptor {
    public EndpointDescriptor(public let name: String, public let path: String, public let typeInfo: TypeInfo) {
    }
}

public class EndpointManager <: Iterable<EndpointDescriptor> {
    private let _items: Collection<EndpointDescriptor>

    public init(items: Collection<EndpointDescriptor>) {
        _items = items
    }

    public func iterator() {
        _items.iterator()
    }
}
