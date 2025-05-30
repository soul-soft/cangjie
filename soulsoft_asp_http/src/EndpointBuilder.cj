package soulsoft_asp_http

import std.collection.*
import soulsoft_extensions_injection.*

public abstract class EndpointBuilder {
    protected init() {
        
    }
    public prop metadata: List<Any>
    public prop delegate: RequestDelegate
    public prop services: IServiceProvider
    public prop displayName: ?String
    public func build(): Endpoint
}
