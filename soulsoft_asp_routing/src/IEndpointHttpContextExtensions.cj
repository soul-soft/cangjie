package soulsoft_asp_routing

public interface IEndpointHttpContextExtensions {
    func setEndpoint(endpoint: Endpoint): Unit
    func getEndpoint(): ?Endpoint
}

extend HttpContext <: IEndpointHttpContextExtensions {
    public func setEndpoint(endpoint: Endpoint): Unit {
        if (let Some(feature) <- this.features.get<IEndpointFeature>()) {
            feature.endpoint = endpoint
        } else {
            this.features.set<IEndpointFeature>(EndpointFeature(endpoint))
        }
    }

    public func getEndpoint(): ?Endpoint {
        if (let Some(feature) <- this.features.get<IEndpointFeature>()) {
            return feature.endpoint
        }
        return None
    }
}
