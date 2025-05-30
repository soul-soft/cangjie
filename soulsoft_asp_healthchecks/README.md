# soulsoft_asp_healthchecks
健康检测中间件，用于执行注册的所有健康检测项，并返回检测的结果。

# dependencies

[soulsoft_asp_http](https://gitcode.com/soulsoft/soulsoft_asp_http.git)
[soulsoft_extensions_healthchecks](https://gitcode.com/soulsoft/soulsoft_extensions_healthchecks.git)  

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