package soulsoft_identity_server.hosting

import std.reflect.*

public class EndpointDescriptor {
    public EndpointDescriptor(public let name: String, public let path: String, public let typeInfo: TypeInfo) {

    }
}

public class EndpointDescriptors  {
    public let items: Collection<EndpointDescriptor>

    public init(items: Collection<EndpointDescriptor>) {
        this.items = items
    }
}