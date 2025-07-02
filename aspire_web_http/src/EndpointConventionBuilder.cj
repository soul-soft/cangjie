package aspire_web_http

public abstract class EndpointConventionBuilder {
    public func add(builder: (EndpointBuilder) -> Unit): Unit
}