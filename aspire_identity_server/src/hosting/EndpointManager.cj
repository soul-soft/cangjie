package aspire_identity_server.hosting

public class EndpointManager <: Iterable<EndpointDescriptor> {
    private let _items: Collection<EndpointDescriptor>

    public init(items: Collection<EndpointDescriptor>) {
        _items = items
    }

    public func iterator() {
        _items.iterator()
    }
}