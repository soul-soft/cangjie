package soulsoft_identity_server.hosting

import std.reflect.*

public class EndpointDescriptor {
    public EndpointDescriptor(public let name: String, public let path: String, public let typeInfo: TypeInfo) {
    }
}