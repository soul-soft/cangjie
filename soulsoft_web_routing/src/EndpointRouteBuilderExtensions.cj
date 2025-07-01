package soulsoft_web_routing

import std.collection.*

extend EndpointRouteBuilder {
    public func mapGet(pattern: String, delegate: RequestDelegate) {
        mapMethods(pattern, delegate, HttpMethods.get)
    }

    public func mapPut(pattern: String, delegate: RequestDelegate) {
        mapMethods(pattern, delegate, HttpMethods.put)
    }

    public func mapHead(pattern: String, delegate: RequestDelegate) {
        mapMethods(pattern, delegate, HttpMethods.head)
    }

    public func mapPatch(pattern: String, delegate: RequestDelegate) {
        mapMethods(pattern, delegate, HttpMethods.patch)
    }

    public func mapTrace(pattern: String, delegate: RequestDelegate) {
        mapMethods(pattern, delegate, HttpMethods.trace)
    }

    public func mapPost(pattern: String, delegate: RequestDelegate) {
        mapMethods(pattern, delegate, HttpMethods.post)
    }

    public func mapDelete(pattern: String, delegate: RequestDelegate) {
        mapMethods(pattern, delegate, HttpMethods.delete)
    }

    public func mapOptions(pattern: String, delegate: RequestDelegate) {
        mapMethods(pattern, delegate, HttpMethods.options)
    }

    public func mapConnect(pattern: String, delegate: RequestDelegate) {
        mapMethods(pattern, delegate, HttpMethods.connect)
    }

    private func mapMethods(routePattern: String, delegate: RequestDelegate, method: String) {
        let dataSource = getOrAddRouteEndpointDataSource()
        return dataSource.addRequestDelegate(routePattern, delegate, method)
    }

    private func getOrAddRouteEndpointDataSource() {
        for (pattern in this.dataSources) {
            if (let foundDataSource: RouteEndpointDataSource <- pattern) {
                return foundDataSource
            }
        }
        let dataSource = RouteEndpointDataSource(this.serviceProivder)
        this.dataSources.add(dataSource)
        return dataSource
    }
}
