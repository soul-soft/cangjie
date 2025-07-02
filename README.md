# aspire

## 许可

MIT

我们正在探索 Cangjie 与 ASP.NET Core 的深度融合，致力于打造：    
✅ 现代化：基于最新 .NET 技术栈的开发范式    
✅ 轻量级：低侵入设计，零冗余依赖    
✅ 可扩展：模块化架构，按需组合功能    
✅ 可插拔：通过 gitcode 配置快速集成
✅ 微服务：我们也将持续构建微服务生态，引入了`jwt`、`oidc`和`identityServer`来构建统一的身份认证中心，以及内置了健康检查基座用于检查服务的运行的健康状况，后续我们还将引入`dapr`和`openapi`的实现    
✅ AI：我们持续关注ai技术，以及探讨ai融入应用的可能性    

诚邀志同道合的开发者加入 aspire 组织，共同构建：    
🔧 标准化组件库    
🔄 统一技术生态   
🌍 开源社区协作平台 
[https://gitcode.com/invite/link/995e1b43629f4773b38c](立即加入)    

如果你想深入了解或者扩展该项目，那么你可以学习`aspire_identity_server`,该项目大量灵活运用了`asp`基础组件和`asp`设计思想

## 内置模块

下面是修复后的表格，其中格式调整正确：

| 模块名称                                  | 描述                         | 必要性  |
|------------------------------------------|------------------------------|--------|
| aspire_web_http                          | HTTP核心接口                  | 必需    |
| aspire_web_mvc                           | MVC                          | 可选    |
| aspire_web_routing                       | 路由与终结点                  | 必需    |
| aspire_web_hosting                       | Web主机                       | 必需    |
| aspire_web_staticfiles                   | 静态文件中间件                | 可选    |
| aspire_web_healthchecks                  | 健康检查中间件                | 可选    |
| aspire_web_authorization                 | 授权中间件                     | 可选    |
| aspire_web_authentication                | 身份认证中间件                | 可选    |
| aspire_web_authentication_jwtbearer      | Jwt身份认证方案               | 可选    |
| aspire_identity_claims                   | 身份声明                      | 可选    |
| aspire_extensions_hosting                | 通用主机                      | 可选    |
| aspire_extensions_logging                | 日志                          | 可选    |
| aspire_extensions_options                | 选项                         | 必需    |
| aspire_extensions_injection              | 依赖注入                      | 可选    |
| aspire_extensions_healthchecks           | 健康检查服务                  | 可选    |
| aspire_extensions_configuration          | 配置管理                      | 可选    |
| aspire_identity_server                   | OAuth2.0，OIDC认证服务         | 可选    |
| aspire_identity_tokens                   | 身份令牌                      | 可选    |
| aspire_identity_tokens_jwt               | Jwt身份令牌                    | 可选    |
| aspire_identity_protocols                | 身份协议                      | 可选    |
| aspire_identity_protocols_oidc           | OIDC协议                      | 可选    |


## 《依赖注入》

1. 基本使用
``` cangjie
//创建容器构建器
let services = ServiceCollection()
//注册单例服务
services.addSingleton<IDbConnection, DbConnection>()
//可以使用工厂模式，来规避反射
services.addSingleton<IDbConnection>(){ sp =>
    DbConnection()
}
//构建容器
let provider = services.build()
//解析服务
let connection = provider.getOrThrow<IDbConnection>()
//解析未注册的服务，但是依赖容器中的服务
let context = ActivatorUtilities.createInstance<DbContext>(provider)
```

2. 生命周期


| 周期                                               | 说明                                                     |
|---------------------------------------------------|----------------------------------------------------------|
| **Singleton**                                     | 单例：一个根容器及其子容器，只创建一个实列                   |
| **Scoped**                                        | 作用域：同一个作用域只创建一个实列，生命周期由业务定义        |
| **Transient**                                     | 瞬时：每次解析都是一个新的实列  

``` cangjie
let services = ServiceCollection()
services.addScoped<IDbConnection, DbConnection>()
let provider = services.build()//根容器
//创建作用域
try (scope = provider.createScope()){
    //子容器
    let connection = scope.services.getOrThrow<IDbConnection>()
}
//作用域结束时会释放该作用域解析的非单例的实列（需要实现Resource接口）。
```

> 注意：通过`ServiceCollection`直接构建的称为`根容器`,通过`ServiceProvider`创建的scope关联的容器称为`子容器`。根容器无法解析非单例的服务。

## 《选项》

选项是对依赖注入模块的扩展和补充，用于统一框架设计者和使用者之间的约定，设计者通过`configure`方法设置默认值，使用者使用者通过`configureAfter`方法修改默认值

1. 基本使用

``` cangjie
//定义一个选项
public class DbConnectionOptions {
    var connectionString = "default"
}
//定义容器
let services = ServiceCollection()
services.configureAfter<DbConnectionOptions>{configureOptions =>
    configureOptions.connectionString = "2.1"
}
services.configureAfter<DbConnectionOptions>{configureOptions =>
    configureOptions.connectionString = "2.2"
}
services.configure<DbConnectionOptions>{configureOptions =>
    configureOptions.connectionString = "1.1"
}
services.configure<DbConnectionOptions>{configureOptions =>
    configureOptions.connectionString = "1.2"
}
//构建容器
let provider = services.build()
//解析选项
let options = provider.getOrThrow<IOptions<DbConnectionOptions>>()
println(options.value.connectionString)//输出2.2
```
> 注意：上面的版本号即执行顺序，无论解析多少次每个lambda函数只执行一次

2. 命名选项

``` cangjie
let services = ServiceCollection()
services.configure<DbConnectionOptions>("tenant1"){configureOptions =>
    configureOptions.connectionString = "1.1"
}
services.configure<DbConnectionOptions>("tenant2"){configureOptions =>
    configureOptions.connectionString = "1.2"
}
let provider = services.build()
let options = provider.getOrThrow<IOptions<DbConnectionOptions>>()
println(options.value.connectionString)
println(options.get("tenant1").connectionString)
println(options.get("tenant2").connectionString)
```
> 命名选项在多租户，多架构场景下非常有用

## 《配置》

配置支持多数据源（命令行参数，环境变量，json）和自定义数据来源。

``` cangjie
main(args: Array<String>) {
    let configurationBuilder = ConfigurationManager()
    //添加命令行参数
    configurationBuilder.addArgVars(args)
    //添加“asp_”开头的环境变量
    configurationBuilder.addEnvVars("asp")
    //添加json配置
    configurationBuilder.addJsonFile("./appsettings.json", true)
    let configuration = configurationBuilder.build()
    println(configuration["help"])
    println(configuration["port"])
    //循环处理所有logging:logLevel节点下的直接属性
    for (pattern in configuration.getSection("logging:logLevel").getChildren()) {
        println("${pattern.key}=${pattern.value}")
    }
    return 0
}
```

appsettings.json

``` json
{
    "logging": {
        "logLevel": {
            "default": "Info",
            "aspire": "Error"
        }
    }
}
```

## 《日志》

日志模块也是应用开发过程中必备可却的组件，日志模块内置了控制台和文件提供程序，同样也支持自定义日志提供程序

1. 基本使用

``` cangjie
let logFactory = LoggingBuilder()
    .addFile()
    .addConsole()
    .build()
let logger = logFactory.createLogger("aspire.logging.test")    
logger.info("hello")
```

2. 使用日志过滤器

``` cangjie
let logFactory = LoggingBuilder()
    .addFile()
    .addConsole()
    .addFilter{providerName, categoryName, logLevel => 
        (providerName == "file" && logLevel >= LogLevel.Error) || 
        (providerName == "console" && logLevel >= LogLevel.Info)
    }
    .build()
let logger = logFactory.createLogger("aspire.logging.test")    
logger.info("hello")//文件中不打印，控制台中打印
logger.error("hello")//文件中打印，控制台中打印
```

3. 使用配置文件过滤

- file提供程序过滤规则:以`asp`结尾的日志，只打印Warn及以上级别的日志    
- console提供程序过滤规则:以`asp`开头的日志，只打印Info及以上级别的日志    
- 默认过滤规则：除上述之外打印Info及以上级别的日志    

``` cangjie
//创建配置
let configurationBuilder = ConfigurationManager()
configurationBuilder.addJsonFile("./appsettings.json", true)
let configuration = configurationBuilder.build()
//创建日志工厂
let logFactory = LoggingBuilder()
    .addFile()
    .addConsole()
    .addConfiguration(configuration.getSection("logging"))
    .build()
//测试
logFactory.createLogger("aspire.asp").info("hello")    
logFactory.createLogger("asp.aspire").info("hello")  
logFactory.createLogger("cangjie").info("hello")    
```

appsettings.json

``` json
{
    "logging": {
        "logLevel": {
            "default": "Info"
        },
        "file": {
            "logLevel": {
                "*.asp": "Warn"
            }
        },
        "console": {
            "logLevel": {
                "asp.*": "Info"
            }
        }
    }
}
```

## 《通用主机》

通用主机整合了上述所有模块，用于处理定时任务和消息队列

1. 创建一个工人和选项

``` cangjie

public class TestWorkerOptions {
    public var delay = 10
}

public class TestWorker <: BackgroundService {
    private let _logger: ILogger

    public TestWorker(let _options: IOptions<TestWorkerOptions>, let _env: IHostEnvironment, let _logFactory: ILoggerFactory) {
        _logger = _logFactory.createLogger<TestWorker>()
    }
    
    public func run() {

        while (!Thread.currentThread.hasPendingCancellation) {
            //不同环境，执行不同逻辑
            if(_env.environmentName == "prod") {
                logger.info("working...")
            }else {
                logger.info("hello...")
            }
            sleep(_options.value.delay * Duration.second)
        }
    }
}
```

2. 定义一个扩展

``` cangjie
extend ServiceCollection{

    public func addTestWorker(configureOptions: (TestWorkerOptions) -> Unit): ServiceCollection {
        this.addHostedService<TestWorker>()
        this.configure<TestWorkerOptions>(configureOptions)
    }
}
```

3. 启动主机

``` cangjie
main(args: Array<String>) {
    let builder = Host.createBuilder(args)
    
    //注册我们的后台服务
    builder.services.addTestWorker()
    
    let host = builder.build()
    
    host.run()
    return 0
}
```
> - 主机内置了`IHostEnvironment`服务，可以通过解析它来区分开发环境还是生成环境    
> - 可以通过`asp_environment`环境变量或者`--environment=test`命令行参数来修改环境名

## 《Web主机》

web主机实现了通用主机，并且在此基础上扩展了http协议，内置请求管道来处理请求逻辑。`aspire`组织提供了了大量的中间件供开发者使用

### 启动一个支持静态文件的web主机

``` cangjie
main(args: Array<String>) {
    let builder = WebHost.createBuilder(args)
    let host = builder.build()

    //当请求网站根路径(/)时，负责查找并返回index.html页面
    host.useDefaultFiles()

    //该中间件负责去wwwroot中查找并返回/xxx.(html|css|js|...)文件
    host.useStaticFiles()

    host.run()

    return 0
}
```

### 启动一个支持动态资源的web主机

``` cangjie
main(args: Array<String>) {
    let builder = WebHost.createBuilder(args)

    builder.services.addRouting()//注册路由中间件需要的服务

    let host = builder.build()

    //useEndpoints：会注册两个中间件，一个负责路由，一个负责执行终结点
    host.useEndpoints { endpoints =>
        endpoints.mapGet("hello") {
            context => context.response.write("hello:aspire")
        }   
    }
    host.run()
    return 0
}
```

> - 路由中间件(EndpointRoutingMiddleware)：负责根据用户输入的`uri`查找对应的`Endpoint`并放到`HttpContext`上（调用`setEndpoint`）
> - 终结点中间件(EndpointMiddleware)：通过调用`HttpContext`上面的`getEndpoint()`方法获取终结点，如果存在`Endpoint`将会执行它

### 健康检查中间件

``` cangjie
main(args: Array<String>) {
    let builder = WebHost.createBuilder(args)

    builder.services.addHealthChecks()
        //添加一个健康检查项
        .addCheck("self") {
            //模拟随机不健康效果
            let random = Random()
            if (random.nextInt32(10) % 2 == 0) {
                HealthCheckResult.healthy()
            } else {
                HealthCheckResult.unhealthy()
            }
        }

    let host = builder.build()

    host.useHealthChecks("/health")

    host.run()

    return 0
}
```

## 《身份认证》

### Basic认证方案

我们在身份认证模块下可以非常方便的实现一个认证方案，比如`Basic`认证方案。身份认证模块为我们处理好了认证和授权流程

``` cangjie
public class BasicAuthenticationDefault {
    public static let scheme = "basic"
}

public class BasicAuthenticationOptions <: AuthenticationSchemeOptions {
    public var realm = "basic"
}

//定义basic认证方案
public class BasicAuthenticationHandler <: AuthenticationHandler<BasicAuthenticationOptions> {
    public init(options: IOptions<BasicAuthenticationOptions>, logger: ILoggerFactory) {
        super(options, logger)
    }

    public func handleAuthenticate() {
        if (let Some(authorization) <- this.context.request.headers.getFirst("Authorization")
            .flatMap{f => fromBase64String(f.replace("Basic ", "")).flatMap{f=> String.fromUtf8(f)} }) {
           
            let secrets = authorization.split(":")
            if (secrets.size == 2) {
                let username = secrets[0]
                let password = secrets[1]
                this.logger.info("username:${username},password:${password}")  
                //通过子容器来解析非单例的服务：IResourceOwnerPasswordValidator  
                let validator = this.context.services.getOrThrow<IResourceOwnerPasswordValidator>()
                if (!validator.validate(username, password)) {
                    return AuthenticateResult.fail(Exception("Invalid username or password"))
                }
                let subject = ClaimsPrincipal()
                let identity = ClaimsIdentity(this.scheme.name)
                identity.addClaim(Claim("username",username))
                identity.addClaim(Claim("password",password))
                subject.addIdentity(identity)
                let ticket = AuthenticationTicket(subject, BasicAuthenticationDefault.scheme)
                return AuthenticateResult.success(ticket)
            }
        }
        return AuthenticateResult.noResult()
    }

    /*
    重写调战处理逻辑:返回401状态码和Basic协议头
    */
    protected override func handleChallenge(properties: ?AuthenticationProperties): Unit {
        this.context.response.addHeader("WWW-Authenticate", "Basic realm=\"${this.options.realm}\", charset=\"UTF-8\"")
        super.handleChallenge(properties)
    }
}

//定义资源所有者凭据验证
public interface IResourceOwnerPasswordValidator {
    func validate(username: String, password: String): Bool
}

//实现资源所有者凭据验证
public class ResourceOwnerPasswordValidator <: IResourceOwnerPasswordValidator {
    let users = HashMap<String, String>([("aspire", "aspire")])

    public func validate(username: String, password: String) {
        if (!users.contains(username)) {
            return false
        }
        return users[username] == password
    }
}
```

启动web主机来运行

``` cangjie
main (args: Array<String>) {
    let builder = WebHost.createBuilder(args)

    builder.services.addRouting()
    
    //注册资源所有者验证器
    builder.services.addTransient<IResourceOwnerPasswordValidator, ResourceOwnerPasswordValidator>()

    //注册身份认证服务
    builder.services.addAuthentication(BasicAuthenticationDefault.scheme)
        //注册basic认证方案
        .addScheme<BasicAuthenticationOptions, BasicAuthenticationHandler>(BasicAuthenticationDefault.scheme)
    
    //注册授权服务
    builder.services.addAuthorizationBuilder()
        //定义授权策略
        .addPolicy("base-policy"){ policy =>
            //必须包含username
            policy.requireClaim("username")
            //基本要求，具体参考源码
            policy.requireAuthenticatedUser()
        }
    let host = builder.build()

    //启用认证中间件
    host.useAuthentication()

    host.useRouting()

    //启用授权中间件
    host.useAuthorization()

    host.run()

    host.useEndpoints { endpoints =>
        endpoints.mapGet("logout") {
            context => context.response.write("logout succeeded")
        }
        //启用认证策略
        .requireAuthorization("base-policy") 
    }
    return 0
}
```

> - 由于`授权中间件`需要使用路由到的`Endpoint`，对终结点授权，因此`授权中间件`必须放到`useRouting`后面
> - 注意：认证是确定你是谁，无论成果与否都不影响流程，而授权，需要验证你的身份，如果身份认证不通过，那么将会发起`challenge`（挑战），并返回401状态码。如果身份认证通过，但是不满足`授权策略`将会发起`forbid`（禁止）返回403状态码。你可以通过override来重写挑战和禁止的逻辑
> - web主机在分发请求的时候，创建了一个子容器放到`HttpContext`的`services`字段上，进而实现请求scope级别的生命周期

### Jwt认证方案



```cangjie
main(args: Array<String>): Int64 {

    let builder = WebHost.createBuilder(args)
    //==============服务注册==================
	
	//注册路由
    builder.services.AddRouting()
    
    //注册身份认证方案
    builder.services.addAuthentication(JwtBearerAuthenticationDefaults.Scheme)
        //注册basic认证方案
        .addScheme<BasicAuthenticationOptions, BasicAuthenticationHandler>(BasicAuthenticationDefault.Scheme)
        //注册jwtBearer认证方案
        .addJwtBearer(JwtBearerAuthenticationDefaults.Scheme) { configureOptions =>
            let securityKey = SymmetricSecurityKey(builder.configuration["authentication:securityKey"].getOrThrow().toArray())
            configureOptions.tokenValidationParameters = TokenValidationParameters(securityKey)
        }
    
    //注册授权服务
    builder.services.addAuthorizationBuilder()
        .addPolicy("default"){ policy =>
            //必须包含username
            policy.requireClaim("username")
            //基本要求，具体参考源码
            policy.requireAuthenticatedUser()
    }

    //==============请求管道==================    
    let host = builder.build()

    //使用身份认证
    host.useAuthentication()

    //动态资源路由（负责路由，并放到HttpContext上）
    host.useRouting()
    
    //由于该中间件需要使用路由到的endpoint，因此必须放到useRouting后面
    host.useAuthorization()
    
    //动态资源(负责注册和执行)
    host.useEndpoints { endpoints =>
		
        //创建jwt token
        endpoints.mapGet("connect/token"){ context =>
            let securityKey = SymmetricSecurityKey(host.configuration["authentication:securityKey"].getOrThrow().toArray())
            let jwtHeader = JwtHeader(SigningCredentials(securityKey, SecurityAlgorithms.HmacSha256))
            let jwtPayload = JwtPayload([("sub", "1024"), ("username", "aspire")])
            
            let jwtTokenHander = JwtSecurityTokenHandler()
            let accessToken = jwtTokenHander.writeToken(JwtSecurityToken(jwtHeader, jwtPayload))
            context.response.write(accessToken)
        }
        
        //登入接口需要授权
        endpoints.mapGet("connect/logout") {
            context => context.response.write("logout succeeded")
        }.requireAuthorization("default")       
    
    }
    host.run()
    return 0
}
```

