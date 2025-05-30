package soulsoft_asp_authorization

import std.collection.*
import soulsoft_asp_http.*

private let ALLOW_ANNOYMOUS = AllowAnonymous()

public interface IAuthorizationEndpointConventionBuilderExtensions {
    func allowAnonymous(): EndpointConventionBuilder
    func requireAuthorization(): EndpointConventionBuilder
    func requireAuthorization(policyNames: Array<String>): EndpointConventionBuilder
    func requireAuthorization(policy: AuthorizationPolicy): EndpointConventionBuilder
    func requireAuthorization(authorizeDatas: Array<IAuthorizeData>): EndpointConventionBuilder
    func requireAuthorization(configurePolicy: (AuthorizationPolicyBuilder) -> Unit): EndpointConventionBuilder
}

extend EndpointConventionBuilder <: IAuthorizationEndpointConventionBuilderExtensions {
    public func allowAnonymous() {
        add {endpoint => endpoint.metadata.add(ALLOW_ANNOYMOUS)}
        return this
    }

    public func requireAuthorization(): EndpointConventionBuilder {
        requireAuthorization(Authorize())
        return this
    }

    public func requireAuthorization(policyNames: Array<String>): EndpointConventionBuilder {
        let authorizeDatas = policyNames |> map {m => Authorize(m)} |> filterMap {f => f as IAuthorizeData} |>
            collectArrayList
        requireAuthorizationCore(authorizeDatas)
        return this
    }

    public func requireAuthorization(authorizeDatas: Array<IAuthorizeData>) {
        requireAuthorizationCore(authorizeDatas)
        return this
    }

    public func requireAuthorization(policy: AuthorizationPolicy): EndpointConventionBuilder {
        requirePolicyCore(policy)
        return this
    }

    public func requireAuthorization(configurePolicy: (AuthorizationPolicyBuilder) -> Unit): EndpointConventionBuilder {
        let policyBuilder = AuthorizationPolicyBuilder()
        configurePolicy(policyBuilder)
        requirePolicyCore(policyBuilder.build())
        return this
    }

    private func requirePolicyCore(policy: AuthorizationPolicy) {
        this.add {
            endpointBuilder =>
            if (!(endpointBuilder.metadata |> any {meta => meta is IAuthorizeData})) {
                endpointBuilder.metadata.add(Authorize());
            }
            endpointBuilder.metadata.add(policy);
        }
    }

    private func requireAuthorizationCore(authorizeDatas: Collection<IAuthorizeData>) {
        for (pattern in authorizeDatas) {
            add {endpoint => endpoint.metadata.add(pattern)}
        }
    }
}
