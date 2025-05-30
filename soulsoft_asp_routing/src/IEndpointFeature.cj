package soulsoft_asp_routing

public interface IEndpointFeature {
    mut prop endpoint: ?Endpoint
}

class EndpointFeature <: IEndpointFeature {
    private var _endpoint: ?Endpoint = None

    init(endpoint: ?Endpoint) {
        _endpoint = endpoint
    }

    public mut prop endpoint: ?Endpoint {
        get() {
            _endpoint
        }
        set(value) {
            _endpoint = value
        }
    }
}
