# aspire_extensions_configuration

配置管理（Configuration）库，用于加载和解析 JSON 配置文件（appsettings.json）、环境变量、命令行参数等，并可以自定义配资源。

# dependencies
  无

# quickstart

## 主要特性

1. **多配置源支持**：支持从多种来源加载配置，如 JSON 文件、环境变量、命令行参数等。
2. **配置覆盖策略**：同名配置项按照后注册的顺序覆盖前面的配置。
3. **复杂数据结构支持**：支持嵌套的 JSON 配置，能够处理复杂的配置结构。

## 内置结构

| 类名                                             | 作用                                                       |
|---------------------------------------------------|----------------------------------------------------------|
| **IConfigurationBuilder**                         | 用于构建 `IConfiguration`，注册 `IConfigurationProvider`   |
| **IConfigurationProvider**                        | 配置源提供程序，实现该接口以扩展配置来源                     |
| **ConfigurationManager**                          | 实现了 `IConfigurationBuilder` 和 `IConfiguration` 接口    |
| **IConfiguration**                                | 配置源接口，提供配置项的读取功能                             |
| **IConfigurationSection**                         | 表示配置中的一个节，支持嵌套配置                             |

---

## 基本使用

### 1. 配置 `launch.json`

在 `.vscode/launch.json` 中配置环境变量和命令行参数：

```json
{
    "configurations": [
        {
            "env": {
                "Path": "c:\\Users\\14483\\Desktop\\demo\\target\\debug\\asp;C:\\Program Files (x86)\\Cangjie\\runtime\\lib\\windows_x86_64_llvm",
                "asp_environment": "dev",
                "asp_web_root_path": "wwwroot",
                "asp_content_root_path": "/root/app",
                "asp_url": "http://127.0.0.1:8080"
            },
            "args": [
                "--url=http://127.0.0.1:80"
            ]
        }
    ]
}
```

### 2. 以调试模式运行示例

在调试模式下运行以下代码，`launch.json` 中的配置将被读取。

```cangjie
package demo

import asp.extensions.configuration.*

main(args: Array<String>): Int64 {
    let manager = ConfigurationManager()
    manager.addEnvVars("asp") // 配置环境变量前缀
    manager.addArgOpts(args)  // 配置命令行参数
    let configuration = manager.build()
    println("url=${configuration.getValue("url")}")
    println("environment=${configuration.getValue("environment")}")
    println("webRootPath=${configuration.getValue("webRootPath")}")
    println("contentRootPath=${configuration.getValue("contentRootPath")}")
    return 0
}
```

### 3. 输出结果

```cmd
url=Some(http://127.0.0.1:80)
environment=Some(dev)
webRootPath=Some(wwwroot)
contentRootPath=Some(/app)
```

### 结论

1. **多数据源支持**：`asp` 支持从环境变量、命令行参数等多种数据源加载配置。
2. **命名风格转换**：环境变量中的 `_` 和命令行参数中的 `-` 会被移除，并使用驼峰命名风格。
3. **配置覆盖**：同名配置项按照后注册的顺序覆盖前面的配置。

---

## 复杂数据结构支持

对于更复杂的配置结构，`asp` 支持从 JSON 文件中加载配置。

### 1. 配置 `appsettings.json`

```json
{
    "logging": {
        "logLevel": {
            "default": "Info",
            "asp.LoggingMiddleware": "Warn"
        },
        "console": {
            "logLevel": {
                "asp.LoggingMiddleware": "Warn"
            }
        }
    },
    "connectionStrings": {
        "mysql": "mysql://127.0.0.1?username=root&password=1024&database=pro"
    }
}
```

### 2. 读取 JSON 配置

```cangjie
package demo

import asp.extensions.configuration.*

main(): Int64 {
    let manager = ConfigurationManager.create { configure =>
        configure.addJsonFile("./appsettings.json", true) // 配置 JSON 文件
    }
    let configuration = manager.build()
    println(manager.getConnectionString("mysql"))
    println(configuration.getValue("connectionStrings:mysql"))
    return 0
}
```

### 3. 操作配置节

```cangjie
main(): Int64 {
    let manager = ConfigurationManager.create { configure =>
        configure.addJsonFile("./config.json", true) // 配置 JSON 文件
    }
    let configuration = manager.build()
    // 获取 logging:logLevel 节
    let section = configuration.getSection("logging:logLevel")
    let children = section.getChildren()
    for (pattern in children) {
        println("key=${pattern.key}, value=${pattern.value}")
    }
    return 0
}
```

### 4. 输出结果

```cmd
key=default, value=Some(Info)
key=asp.LoggingMiddleware, value=Some(Warn)
```

---

## 总结

`ConfigurationManager` 提供了强大的配置管理功能，支持多种配置源和复杂的数据结构。通过灵活的环境变量、命令行参数和 JSON 文件配置，开发者可以轻松管理应用程序的配置项。

![配置模块示意图](https://example.com/config-module-diagram.png)

*图：配置模块的工作流程示意图*

通过合理使用 `ConfigurationManager`，开发者可以构建出灵活、可扩展的应用程序配置系统。