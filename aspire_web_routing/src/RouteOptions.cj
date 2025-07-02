package aspire_web_routing

import std.random.Random
import std.collection.*

public class RouteOptions {
    private let _endpointDataSources = HashSet<EndpointDataSource>()

    public prop endpointDataSources: HashSet<EndpointDataSource> {
        get() {
            _endpointDataSources
        }
    }
}
