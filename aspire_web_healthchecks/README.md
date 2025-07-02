# aspire_web_healthchecks
健康检测中间件，用于执行注册的所有健康检测项，并返回检测的结果。

# dependencies

[aspire_web_http](https://gitcode.com/aspire/aspire_web_http.git)
[aspire_extensions_healthchecks](https://gitcode.com/aspire/aspire_extensions_healthchecks.git)  

# quickstart

``` cangjie
main() {
    let builder = WebHost.createBuilder()
    builder.services.addHealthChecks()
        .addCheck("self") {
            HealthCheckResult.healthy()
        }
    let host = builder.build()
    host.useHealthChecks("/health")
    host.run()
    return 0
}
```