package aspire_web_routing

import std.collection.*

public class EndpointRouteBuilder {
    private let _serviceProivder: IServiceProvider
    private let _dataSources = ArrayList<EndpointDataSource>()

    init(serviceProivder: IServiceProvider) {
        _serviceProivder = serviceProivder
    }

    public prop serviceProivder: IServiceProvider {
        get() {
            _serviceProivder
        }
    }

    public prop dataSources: List<EndpointDataSource> {
        get() {
            _dataSources
        }
    }
}
