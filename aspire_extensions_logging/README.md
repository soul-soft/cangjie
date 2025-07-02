# aspire_extensions_logging

日志记录（logging）组件，提供了模块化、可扩展的日志记录框架，支持 控制台、文件等多种日志存储方式，并可以自定义存储介质。

# dependencies
  [aspire_extensions_configuration](https://gitcode.com/aspire/aspire_extensions_configuration.git)

# quickstart

asp内置了`控制台日志提供程序`和`文件提供程序`(慎用，存在线程问题)，以及日志过滤器，并且支持通过配置文件来配置日志过滤器

## 内置结构

| 类名                                              | 作用                                                      |
|---------------------------------------------------|----------------------------------------------------------|
| **LoggingBuilder**                                | 用于构建ILoggerFactory，注册日志提供程序                    |
| **ILoggerProvider**                               | 日志提供程序，实现此接口可以将日志写入到目标介质              |
| **ILoggerFactory**                                | 日志工厂，用于创建ILogger                                  |
| **ILogger**                                       | 日志对象，用于输出日志                                      |

## 构建日志

```cangjie
package demo

import asp.extensions.logging.*

main(): Int64 {
    let builder = LoggingBuilder()
        .addFile()
        .addConsole()

    let logFactory = builder.build()
    let logger = logFactory.createLogger("asp.demo.main")
    logger.info("hello asp")
    return 0
}
```
运行此example，会发现在控制台和本地文件都打印了日志

## 设置日志最低级别


```cangjie
main(): Int64 {
    let builder = LoggingBuilder()
        .setMinimumLevel(LogLevel.Warn)
        .addFile()
        .addConsole()

    let logFactory = builder.build()
    let logger = logFactory.createLogger("asp.demo.main")
    logger.info("hello asp")
    logger.warn("hello asp")
    logger.error("hello asp")
    return 0
}
```
运行此example，会发现只打印了warn，error级别的日志信息


## 通过lambda过滤

```cangjie

main(): Int64 {
    let builder = LoggingBuilder()
        .setMinimumLevel(LogLevel.Warn)
        .addFile()
        .addFilter { _: String, categoryName: String, _: LogLevel => 
            return categoryName.contains("asp")
        }
        .addConsole()

    let logFactory = builder.build()
    let logger1 = logFactory.createLogger("asp.demo.main")
    let logger2 = logFactory.createLogger("cj.demo.main")
    logger1.info("hello asp")
    logger2.info("hello cj")
    return 0
}
```

运行此example会发现只有logger1输出了，此时setMinimumLevel不管用了，因为它的优先级最低，具体参考`LoggerRuleSelector`源码

## 通过配置文件进行配置

``` cangjie
main(): Int64 {
    //创建配置源
    let configuration = ConfigurationManager.create{builder =>
        builder.addJsonFile("./config.json", false)
    }.build()

    let builder = LoggingBuilder()
        .setMinimumLevel(LogLevel.Info)        
        .addConfiguration(configuration.getSection("logging"))
        .addFile()
        .addConsole()

    let logFactory = builder.build()
    let logger1 = logFactory.createLogger("asp.demo.main")
    let logger2 = logFactory.createLogger("cj.demo.main")
    logger1.info("hello asp")
    logger1.error("hello asp")
    logger2.info("hello cj")
    logger2.error("hello cj")
    return 0
}

```

* ./config.json
``` json
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

运行此example会发现

* console

``` cmd
error: asp.demo.main
      hello asp
info: cj.demo.main
      hello cj
error: cj.demo.main
      hello cj
```

* file

```
error: 2025-01-18 17:12:45, asp.demo.main
	hello asp
info: 2025-01-18 17:12:45, cj.demo.main
	hello cj
error: 2025-01-18 17:12:45, cj.demo.main
	hello cj
```

结论：
1. console要求asp开头的日志最低级别为Warn
2. file要求asp开头的日志级别为Error
3. 否则日志级别都按Info
