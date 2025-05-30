# soulsoft_extensions_healthchecks

健康检测规范，你可以基于该模块编写相应的中间件健康状况的检测。

# dependencies

(soulsoft_extensions_options)[https://gitcode.com/soulsoft/soulsoft_extensions_options.git]  
(soulsoft_extensions_injection)[https://gitcode.com/soulsoft/soulsoft_extensions_injection.git]  

# quickstart

如果你需要实现健康检测项扩展，请参考下面的代码

``` cangjie
public interface MySqlHealthChecksBuilderExtensions {
    func addMysqlCheck(connectionString: String): HealthChecksBuilder
}
extend HealthChecksBuilder <: MySqlHealthChecksBuilderExtensions {
    public func addMysqlCheck(connectionString: String): HealthChecksBuilder {
        addCheck("mysql") {
            //编写检测逻辑
            HealthCheckResult.healthy()
        }
        return this
    }
}

```