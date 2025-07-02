package aspire_web_routing

import std.reflect.*
import std.collection.*

public abstract class EndpointDataSource <: Equatable<EndpointDataSource> & Hashable {

    public prop endpoints: ReadOnlyList<Endpoint>

   
    public operator func ==(oth: EndpointDataSource) {
        refEq(this, oth)
    }

    public func hashCode() {
        ClassTypeInfo.of(this).hashCode()
    }
}
