package soulsoft_asp_http

public abstract class EndpointConventionBuilder {
    public func add(builder: (EndpointBuilder) -> Unit): Unit
}