package soulsoft_asp_hosting

import std.convert.*
import std.collection.*
import stdx.encoding.url.*
import stdx.log.LogLevel as ServerLogLevel
import stdx.net.http.HttpContext as HttpContextBase
import stdx.net.http.{FuncHandler, ServerBuilder, HttpRequestDistributor, HttpRequestHandler}

public class HttpServer {
    private let _app: RequestDelegate
    private let _services: IServiceProvider
    private let _shutdownEvents = ArrayList<() -> Unit>()

    init(app: RequestDelegate, services: IServiceProvider) {
        _app = app
        _services = services
    }

    public func listen(urls: Array<String>) {
        let url = URL.parse(urls[0])
        let builder = ServerBuilder()
            .addr(url.hostName)
            .port(UInt16.parse(url.port.toString()))
            .distributor(DefaultHttpRequestDistributor(_app, _services))
        for (pattern in _shutdownEvents) {
            builder.onShutdown(pattern)
        }
        let server = builder.build()
        server.logger.level = ServerLogLevel.OFF
        server.serve()
    }

    public func onShutdown(callback: () -> Unit) {
        _shutdownEvents.add(callback)
        return this
    }
}

class DefaultHttpRequestDistributor <: HttpRequestDistributor {
    private let _handler: RequestDelegate
    private let _services: IServiceProvider

    init(handler: RequestDelegate, services: IServiceProvider) {
        _handler = handler
        _services = services
    }

    public func register(_: String, _: HttpRequestHandler): Unit {
    }

    public func register(_: String, _: (HttpContextBase) -> Unit): Unit {
    }

    public func distribute(_: String) {
        return FuncHandler {
            //创建请求作用域子容器
            context => try (requestScope = _services.createScope()) {
                let contextImpl = HttpContextImpl(context, requestScope.services)
                _handler(contextImpl)
            }
        }
    }
}
