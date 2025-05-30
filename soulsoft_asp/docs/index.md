# soulsoft_asp 核心功能详解

## 依赖注入系统

soulsoft_asp 的依赖注入(DI)是其核心架构，提供轻量级且高效的实现，支持完整的生命周期管理。

### 基础服务定义

```cangjie
// 抽象数据库连接基类
public abstract class DbConnection <: Resource & ToString {
    protected let id = DateTime.now().toString()
}

// SQL Server 连接实现
public class SqlConnection <: DbConnection {
    private var _isClosed = false

    public func isClosed() => _isClosed

    public func close() {
        if (isClosed()) return
        _isClosed = true
        println("[${id}]SqlConnection:closed")
    }

    public func toString() => "SqlConnection"
}

// MySQL 连接实现
public class MySqlConnection <: DbConnection {
    private var _isClosed = false

    public func isClosed() => _isClosed

    public func close() {
        if (isClosed()) return
        _isClosed = true
        println("[${id}]MySqlConnection:closed")
    }

    public func toString() => "MySqlConnection"
}

// 数据库上下文
public class DbContext <: ToString {
    public DbContext(let _connection: DbConnection) {}

    public func toString() => "DbContext:${_connection}"
}
```

### DI 核心特性演示

```cangjie
import soulsoft_extensions_injection.*

main(): Int64 {
    // 1. 服务注册
    let services = ServiceCollection()
    services.addScoped<DbConnection, SqlConnection>()  // 注册第一个实现
    services.addScoped<DbConnection, MySqlConnection>() // 覆盖前一个注册
    services.addScoped<DbContext, DbContext>()         // 注册依赖服务

    // 2. 构建服务提供者
    let provider = services.build()

    // 3. 作用域生命周期验证
    try (scope = provider.createScope()) {
        let context = scope.services.getOrThrow<DbContext>()
        println(context) // 输出 DbContext 信息
    }

    // 4. 同一作用域实例验证
    try (scope = provider.createScope()) {
        let context1 = scope.services.getOrThrow<DbContext>()
        let context2 = scope.services.getOrThrow<DbContext>()
        println(refEq(context1, context2)) // 输出 true，同一实例
    }
    return 0
}
```

### 生命周期类型对比

**单例模式示例**:
```cangjie
main(): Int64 {
    let services = ServiceCollection()
    services.addSingleton<DbConnection, SqlConnection>()

    let provider = services.build()
    println("根容器实例1:" + provider.getOrThrow<DbConnection>().toString())
    println("根容器实例2:" + provider.getOrThrow<DbConnection>().toString())

    try (scope = provider.createScope()) {
        println("作用域实例1:" + scope.services.getOrThrow<DbConnection>().toString())
        println("作用域实例2:" + scope.services.getOrThrow<DbConnection>().toString())
    }
    return 0
}
```

**作用域模式示例**:
```cangjie
main(): Int64 {
    let services = ServiceCollection()
    services.addScoped<DbConnection, SqlConnection>()

    let provider = services.build()

    try (scope = provider.createScope()) {
        println("作用域1实例1:" + scope.services.getOrThrow<DbConnection>().toString())
        println("作用域1实例2:" + scope.services.getOrThrow<DbConnection>().toString())
    }

    try (scope = provider.createScope()) {
        println("作用域2实例1:" + scope.services.getOrThrow<DbConnection>().toString())
        println("作用域2实例2:" + scope.services.getOrThrow<DbConnection>().toString())
    }
    return 0
}
```

### ActivatorUtilities

> 由于DbContext中依赖了一个字符串，而容器中又不存在这个服务，但又依赖了容器中的服务，此时我们可以通过ActivatorUtilities来简化创建
> 方式1比方式2反射，假设存在大量依赖项的情况下。但是方式一性能由于方式2（非单例场景很有效），因为方式1可以规避反射机制

**用于注入**

``` cangjie
public class DbConnection {}
public class DbContext {
    public DbContext(let _connection: let _name){}
}

main() {
    let services = ServiceCollection()
    services.addSingleton<DbConnection, DbConnection>()
    //方式1
    services.addSingleton<DbContext>{ sp => 
        DbContext(sp.getOrThrow<DbConnection>(), "default")
    }
    //方式2
    services.addSingleton<DbContext>{ sp => 
        ActivatorUtilities.createInstance<DbContext>(sp, "default")
    }
    return 0
}
```

**用于解析**

> 注意：ActivatorUtilities解析的服务生命周期不受容器管理，但是依赖项受容器管理。有时存在我们不需要注册的服务，但是又依赖了容器中的服务，可以通过它来简化创建
``` cangjie
public class DbConnection {}
public class DbContext {
    public DbContext(let _connection: let _name){}
}

main() {
    let services = ServiceCollection()
    services.addSingleton<DbConnection, DbConnection>()
    let provider = services.build()
    let context = ActivatorUtilities.createInstance<DbContext>(provider, "default")
    return 0
}
```




## 配置选项系统

### 基础选项配置

configureAfter一定在所有的`configure`之后执行，多个`configure`或`configureAfter`按照顺序执行

> 说明：约定框架内调用`configure`，`configureAfter`提供给用户调用
```cangjie
import soulsoft_extensions_options.*
import soulsoft_extensions_injection.*

main(): Int64 {
    let services = ServiceCollection()
    
    // 用户覆盖配置（始终在框架配置后执行）
    services.configureAfter<DbConnectionOptions> { opts =>
        opts.connectionString = "用户自定义连接字符串"
        println("用户配置已覆盖")
    }

    // 框架默认配置
    services.configure<DbConnectionOptions> { opts =>
        opts.connectionString = "默认连接字符串"
        println("框架默认配置已设置")
    }
    

    let provider = services.build()
    let options = provider.getOrThrow<IOptions<DbConnectionOptions>>()
    println("最终配置值: " + options.value.connectionString)
    return 0
}

public class DbConnectionOptions {
    public var connectionString = ""
}
```

### 多租户选项配置

```cangjie
main(): Int64 {
    let services = ServiceCollection()
    
    // 租户特定配置
    services.configure<DbConnectionOptions>("tenant1") { opts =>
        opts.connectionString = "租户1连接字符串"
    }
    
    services.configure<DbConnectionOptions>("tenant2") { opts =>
        opts.connectionString = "租户2连接字符串"
    }

    let provider = services.build()
    let options = provider.getOrThrow<IOptions<DbConnectionOptions>>()
    
    println("租户1配置: " + options.get("tenant1").connectionString)
    println("租户2配置: " + options.get("tenant2").connectionString)
    return 0
}
```

## 统一配置管理系统

```cangjie
import soulsoft_extensions_configuration.*

main(args: Array<String>): Int64 {
    // 配置构建器，后注册的会覆盖先注册的同名key
    let configManager = ConfigurationManager()
        .addArgVars(args)                  // 命令行参数
        .addEnvVars("ASP")                // 环境变量(ASP_前缀)
        .addJsonFile("appsettings.json")  // JSON配置文件
        
    let config = configManager.build()
    
    println("应用名称: " + config["name"])
    println("系统目录: " + config["HOME"])
    return 0
}
```

## 日志记录系统

### 基础日志记录

```cangjie
import soulsoft_extensions_logging.*

main(): Int64 {
    let loggerFactory = LoggingBuilder()
        .addConsole()  // 添加控制台输出
        .build()
        
    loggerFactory.createLogger("app.startup").info("应用启动中...")
    loggerFactory.createLogger("app.runtime").debug("运行中...")
    return 0
}
```

### 日志过滤配置

```cangjie
import soulsoft_extensions_logging.*

main(): Int64 {
    let loggerFactory = LoggingBuilder()
        .addFilter { provider, category, level =>
            category.startsWith("app.")  // 只记录app开头的日志
        }
        .addConsole()
        .build()

    loggerFactory.createLogger("app.core").info("核心模块加载")  // 会记录
    loggerFactory.createLogger("system.io").warn("IO警告")     // 被过滤
    return 0
}
```

### 基于配置的日志系统

`appsettings.json`:
```json
{
    "logging": {
        "logLevel": {
            "default": "Info",
            "system": "Warn"
        },
        "console": {
            "logLevel": {
                "app": "Debug"
            }
        }
    }
}
```

```cangjie
import soulsoft_extensions_logging.*
import soulsoft_extensions_configuration.*
import soulsoft_extensions_logging_configuration.*

main(): Int64 {
    let config = ConfigurationManager()
        .addJsonFile("appsettings.json", true)
        .build()

    let loggerFactory = LoggingBuilder()
        .addConsole()
        .addConfiguration(config.getSection("logging"))
        .build()

    loggerFactory.createLogger("app.startup").debug("调试信息")  // 会显示
    loggerFactory.createLogger("system.net").info("网络信息")    // 被过滤
    return 0
}
```

## 通用主机系统

### 基础主机应用

```cangjie
import soulsoft_extensions_hosting.*

main(args: Array<String>): Int64 {
    let builder = Host.createBuilder(args)
    let host = builder.build()
    host.run()
    return 0
}
```

### 后台服务实现

```cangjie
import soulsoft_extensions_hosting.*
import soulsoft_extensions_injection.*
import soulsoft_extensions_options.*
import soulsoft_extensions_logging.*

// 后台服务选项
public class WorkerOptions {
    public var interval = 5  // 默认5秒间隔
}

// 后台服务实现
public class BackgroundWorker <: BackgroundService {
    public BackgroundWorker(
        let _logger: ILogger<BackgroundWorker>,
        let _options: IOptions<WorkerOptions>
    ) {}

    public func run() {
        while (!Thread.currentThread.hasPendingCancellation) {
            _logger.info("后台任务执行中...")
            sleep(Duration.seconds(_options.value.interval))
        }
    }
}

public interface BackgroundWorkerExtension {
    func addBackgroundWorker(): ServiceCollection
}

// 服务扩展方法
extend ServiceCollection <: BackgroundWorkerExtension {
    public func addBackgroundWorker() {
        this.addHostedService<BackgroundWorker>()
        this.addOptions<WorkerOptions>()
    }
}

// 应用入口
main(args: Array<String>): Int64 {
    let builder = Host.createBuilder(args)
    //可以确认configureAfter一定覆盖，因为大家都有遵守options的约定
    builder.configureAfter<WorkerOptions> { opts =>
        opts.interval = 10  // 配置工作间隔
    }
    builder.services.addBackgroundWorker()
    let host = builder.build()
    host.run()
    return 0
}
```

以上实现展示了soulsoft_asp风格的核心功能模块，包括依赖注入、配置管理、日志系统和后台服务，这些模块协同工作为应用程序提供了坚实的基础设施支持。


## Web主机

web主机是对通用主机的扩展，主要扩展了`请求管道`，因此通用主机支持的web主机一样支持，即你也可以在web主机运行后台服务。

web主机和通用主机的区别除了`请求管道`之外，还启动了一个http服务器，用于监听http请求，并创建了一个请求作用域的容器（放入了HttpContext）

参考源码：[HttpServer.cj](https://gitcode.com/soulsoft/soulsoft_asp_hosting/blob/main/src/HttpServer.cj)

``` cangjie

public func distribute(_: String) {
    return FuncHandler {
        //创建请求作用域子容器
        context => try (requestScope = _services.createScope()) {                
            let contextImpl = HttpContextImpl(context, requestScope.services)
            //init context accessor
            if (let Some(contextAccessor) <- contextImpl.services.getOrDefault<IHttpContextAccessor>()) {
                if (let internalContextAccessor: HttpContextAccessor <- contextAccessor) {
                    internalContextAccessor.setup(contextImpl)
                }
            }
            _handler(contextImpl)
        }
    }
}
```



> 请求管道：可以把请求看作水从一个管子的一头流向另一头，我们可以在管道中加入各种过滤器来对水净化。请求管道的实现算法可以参考：[example](https://gitcode.com/Cangjie/Cangjie-Examples/tree/0.53.18/RequestPipeline)，通过依赖注入+请求管道可以实现可插拔可扩展轻量级现代化应用


### mini-api
``` cangjie
//需要引入soulsoft_asp_routing模块
main(args: Array<String>): Int64 {
    let builder = WebHost.createBuilder(args)
    
    //soulsoft_asp_routing模块对容器的扩展
    builder.services.addRouting()
    
    let host = builder.build()
    
    //soulsoft_asp_routing模块对管道的扩展
    host.useEndpoints { endpoints =>
        endpoints.mapGet("mini/hello") {
            context => context.response.write("hello:soulsoft")
        }
    }
    host.run()
    return 0
}

```

### mvc

* 我们可以引入soulsoft_asp_mvc模块实现controller-action-model的webapi开发模式

> 我们提供了大量的可插拔的中间件模块，比如：    
> `soulsoft_asp_http`:定义了基础的http协议类    
> `soulsoft_asp_staticfiles`:处理静态资源请求    
> `soulsoft_asp_routing`:定义了基础的动态资源路由和流程    
> `soulsoft_asp_mvc`:处理模型mvc模式的webapi    
> `soulsoft_extensions_healthchecks`:处理健康检查服务(你可以依赖该模块扩展健康检查项，比如mysql，redis等等)    
> `soulsoft_asp_healthchecks`:运行健康检查服务的中间件  
> `soulsoft_asp_authoriaztion`:定义了基础的身份认证流程
> `soulsoft_extensions_caching`:定义了缓存标准接口，第三方必须实现该接口，简化asp用户切换存储的压力   
``` cangjie
main(args: Array<String>): Int64 {
    let builder = WebHost.createBuilder(args)
    
    //soulsoft_asp_routing模块对容器的扩展
    builder.services.addControllers()
        .addApplicationPart("default", TypeInfo.of<EntityController>())

    let host = builder.build()
    
    //soulsoft_asp_routing模块对管道的扩展
    host.useEndpoints { endpoints =>
         
        //soulsoft_asp_mvc模块对endpoints的扩展
        endpoints.mapControllers()
    }
    host.run()
    return 0
}

@Route["api/[controller]"]
public class EntityController <: Controller {
    public EntityController(let _env: IWebHostEnvironment) {
    }

    @HttpGet
    public func get(@FromServices logFactory: ILoggerFactory, @FromQuery model: CreatingModel) {
        let logger = logFactory.createLogger<EntityController>()
        logger.info("home:get")
        return json(model)
    }

    @HttpGet["{id}"]
    public func get(@FromServices logFactory: ILoggerFactory, @FromRoute id: Int64) {
        for ((key, value) in request.routeValues) {
            println("${key} = ${value}")
        }
        let logger = logFactory.createLogger<EntityController>()
        logger.info("entity:get/{id}")
        return content(id.toString())
    }

    @HttpDelete["{id}"]
    public func delete(@FromServices logFactory: ILoggerFactory, @FromRoute id: Int64) {
        let logger = logFactory.createLogger<EntityController>()
        logger.info("entity:delete/{id}")
        return content(id.toString())
    }

    @HttpPost
    public func post(@FromServices logFactory: ILoggerFactory, model: CreatingModel) {
        let logger = logFactory.createLogger<EntityController>()
        logger.info("entity:post")
        return json(model)
    }

    @HttpPut
    public func put(@FromServices logFactory: ILoggerFactory, @FromForm model: CreatingModel) {
        let logger = logFactory.createLogger<EntityController>()
        logger.info("entity:put")
        return json(model)
    }
}
```

### 使用健康检查+静态文件中间件

> 请添加相关依赖

``` cangjie
main(): Int64 {
    let builder = WebHost.createBuilder(["environment=test"])
    //==============服务注册==================

    builder.services.addRouting()

    //注册健康检查项
    builder.services.addHealthChecks()
        .addCheck("self") {
            let random = Random()
            if (random.nextInt32(10) % 2 == 0) {
                HealthCheckResult.healthy()
            } else {
                let data = HashMap<String, Object>()
                HealthCheckResult.unhealthy(data: data)
            }
        }

    //==============请求管道==================    
    let host = builder.build()

    //注册健康检查
    host.useHealthChecks("/health")

    //默认静态资源
    host.useDefaultFiles()

    //静态资源
    host.useStaticFiles()

    host.run()

    host.useEndpoints { endpoints =>
        endpoints.mapGet("mini/hello") {
            context => context.response.write("hello:soulsoft")
        }
    }
    return 0
}
```

### 实现一个简单的openapi中间件

``` cangjie
public class OpenApiMiddleware <: IMiddleware {
    private let _dataSource: EndpointDataSource

    //EndpointDataSource由routing模块注入到容器（调用services.addRouting()）
    public init(dataSource: EndpointDataSource) {
        _dataSource = dataSource
    }

    public func invoke(context: HttpContext, next: () -> Unit): Unit {
        if (context.request.url.path == "/openapi") {
            let sb = StringBuilder()
            sb.append("<html>")
            sb.append("<body>")
            for (pattern in _dataSource.endpoints |> filterMap {f => f as RouteEndpoint}) {
                let methods = pattern.metadata |> filterMap{f => f as IHttpMethodMetadata} |> flatMap{f => f.httpMethods} |> collectArray
                sb.append("<a href='${pattern.routePattern}'>${methods}${pattern.routePattern}</a><br/>")
            }
            sb.append("</body>")
            sb.append("</html>")
            context.response.write(sb.toString())
            context.response.addHeader("context-type", "text/html")
        } else {
            next()
        }
    }
}
```

加入请求管道

``` cangjie
let buider = Host.createBuilder()

builder.addRouting()

let host = builder.buid()

host.use<OpenApiMiddleware>()

host.useEndpoints{ endpoints => 
    endpoints.mapGet("/test1") {context =>

    }
}
```


### 在动态终结点（Endpoint）执行之前获取到Endpoint

这个功能在身份认证时很有用，比如我们需要判断Endpoint中是否存在`AllowAnonymous`注解来决定是否运行身份认证检查

``` cangjie
let buider = Host.createBuilder()

builder.addRouting()

let host = builder.buid()

host.use<OpenApiMiddleware>()

//如果我们主动调用addRouting，useEndpoints就不会插入RouteMiddleware中间件
host.addRouting()

//那么我们就可以在RouteMiddleware中间件和EndpointMiddleware直接插入一个过滤器，完成特定操作
host.use{context, next => 
    if(let Some(endpoint) <- context.getEndpoint()) {
        endpoint.metadata//上面存放了很多有用的信息
    }
}

//useEndpoints注册了RouteMiddleware(负责查找Endpoint放到httpContext上)中间件和EndpointMiddleware（负责执行路由到的Endpoint）中间件
host.useEndpoints{ endpoints => 
    endpoints.mapGet("/test1") {context =>

    }
}
```



