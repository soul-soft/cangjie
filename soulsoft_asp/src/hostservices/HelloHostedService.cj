package soulsoft_asp.hostservices

import std.reflect.*
import soulsoft_extensions_options.*
import soulsoft_extensions_hosting.*
import soulsoft_extensions_logging.*

public class HelloHostedService <: BackgroundService {
    public HelloHostedService(let _options: IOptions<HelloHostedServiceOptions>, let _logFactory: ILoggerFactory) {
    }
    public func run() {
        let loggerA = _logFactory.createLogger("aaa.HelloHostedService")
        let loggerB = _logFactory.createLogger("bbb.HelloHostedService")//将被过滤
        let loggerT = _logFactory.createLogger<HelloHostedService>()

        loggerA.info("delary:${_options.value.delay}")
        loggerB.info("delary:${_options.value.delay}")
        loggerT.info("delary:${_options.value.delay}")

        while (!Thread.currentThread.hasPendingCancellation) {
            sleep(_options.value.delay * Duration.second)
            loggerA.info("hello")
            loggerB.info("hello")
            loggerT.info("hello")
        }
    }
}
