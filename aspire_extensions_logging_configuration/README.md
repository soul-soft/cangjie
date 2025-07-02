# aspire_extensions_logging_configuration

通过配置文件来扩展日志过滤

# quickstart

`main`

``` cangjie
//构建配置
let configuration = ConfigurationManager()
    .addJsonFile("./appsettings.json", true)

let builder = LoggingBuilder()
builder.addConsole()
let loggingConfiguration = configuration.getSection("logging")
builder.addConfiguration(loggingConfiguration)
```

`appsettings.json`

logging:logLevel:默认规则  
logging:{provider}:根据日志提供程序配置

``` cangjie
{
    "logging": {
      "logLevel": {
        "default": "Info"
      },
      "file":{
        "logLevel": {
          "asp": "Error"
        }
      },
      "console":{
        "logLevel": {
          "asp": "Warn"
        }
      }
    }
}
```