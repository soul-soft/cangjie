package soulsoft_identity_server.hosting

import std.reflect.*

public interface IEndpointFactory {
    func create(typeInfo: TypeInfo): IEndpointHandler
}