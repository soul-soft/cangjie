# aspire_extensions_injection
依赖注入（DI）框架，用于管理应用程序中的 依赖对象的创建和生命周期。提供了模块化、可扩展的方式来管理组件依赖。

# dependencies
无

# quickstart

## 内置结构

| 类名                                               | 作用                                                      |
|---------------------------------------------------|----------------------------------------------------------|
| **ServiceDescriptor**                             | 服务的描述信息                                             |
| **ServiceCollection**                             | 用于保存服务的描述信息集合                                  |
| **IServiceScope**                                 | 用于控制容器生命周期和释放权限分离|
| **IServiceProvider**                               | 服务提供者，用于解析服务                                    |
| **ActivatorUtilties**                             | 用于创建没有注册描述信息但是依赖了容器依赖项的实列             |


## 生命周期

| 周期                                               | 说明                                                     |
|---------------------------------------------------|----------------------------------------------------------|
| **Singleton**                                     | 单例：一个根容器及其子容器，只创建一个实列                   |
| **Scoped**                                        | 作用域：同一个作用域只创建一个实列，生命周期由业务定义        |
| **Transient**                                     | 瞬时：每次解析都是一个新的实列                              |

## 基本使用

``` cangjie
let services = ServiceCollection()
//注册单列
services.addSingleton(DbContext())
services.addSingleton<IDbConnection, MySqlConnection>()
services.addSingleton<IDbConnection, PgsqlConnection>()
//通过工厂模式(无反射)，可以实现更加灵活的配置，并且可以通过sp来解析其它服务
services.addSingleton<DbContext>({ sp => 
    return DbContext(sp.getOrThrow<IDbConnection>())
})
//如果依赖的服务太多，你可以使用ActivatorUtilities
services.addSingleton<DbContext>({ sp =>
    //ActivatorUtilities不仅可以去容器里查找，还可以通过第二个参数列表来查找服务
    return ActivatorUtilities.createInstance<DbContext>(sp, "mysql://127.0.0.1:3306")
})
let provider = services.build()

//你可以配置选项来快速定位是否存在循环依赖（生产环境，不建议开启，前提是你已经确认不存在循环依赖，循环依赖会导致堆栈溢出）
//let provider = services.build{options => 
//  options.validateLoopDependency = true
//}

let context = provider.getOrDefault<DbContext>()
//IDbConnection:有多个实现，默认返回最后一个
let connection = provider.getOrDefault<IDbConnection>()
//获取所有实现
let connections = provider.getAll<IDbConnection>()
```

## 测试服务

``` cangjie
import std.time.*

public interface IDbContext <: ToString & Resource {
   
}

public class SqlDbContext <: IDbContext {
    private var _isClosed = false
    private let id = DateTime.now().toString()

    public func toString() {
       "Sql:${id}"
    }

    public func close() {
        println("${id}:已释放")
        _isClosed = true
    }

    public func isClosed() {
        return _isClosed
    }
}

public class MySqlDbContext <: IDbContext {
    private var _isClosed = false
    private let id = DateTime.now().toString()

    public func toString() {
        "MySql:${id}"
    }

    public func close() {
        println("${id}:已释放")
        _isClosed = true
    }

    public func isClosed() {
        return _isClosed
    }
}

public class DbConnection {

}
public class DbContext {
    let _connect: DbConnection
    public init(connect: DbConnection) {
        _connect = connect
    }
}
```
## 创建根容器

运行此实列，会打印服务的id信息，随后伴随着rootScope的释放而自动释放

``` cangjie
let services = ServiceCollection()
services.addSingleton<IDbContext, SqlDbContext>()
//创建根容器作用域
try (rootScope = services.createRootScope()) {
    let context = rootScope.services.getOrThrow<IDbContext>()
    println(context)
}
```

运行结果

``` cmd
Sql:2025-01-26T20:51:35.1522946+08:00   
2025-01-26T20:51:35.1522946+08:00:已释放
```

### 测试单例场景

``` cangjie
let services = ServiceCollection()
services.addSingleton<IDbContext, SqlDbContext>()
//创建根容器作用域
try (rootScope = services.createRootScope()) {
    //context1,context2都通过根容器创建
    let context1 = rootScope.services.getOrThrow<IDbContext>()
    let context2 = rootScope.services.getOrThrow<IDbContext>()
    println("context1:${context1}")
    println("context2:${context2}")
    //创建请请求作用域
    try (requestScope = rootScope.services.createScope()) {
        //context3,context4都通过子容器创建
        let context3 = requestScope.services.getOrThrow<IDbContext>()
        let context4 = requestScope.services.getOrThrow<IDbContext>()
        println("context3:${context3}")
        println("context4:${context4}")
    }
}
```
运行结果:无论什么作用域，创建多少次，都只创建了一个实列

``` cmd
context1:Sql:2025-01-26T20:54:21.5031824+08:00
context2:Sql:2025-01-26T20:54:21.5031824+08:00
context3:Sql:2025-01-26T20:54:21.5031824+08:00
context4:Sql:2025-01-26T20:54:21.5031824+08:00
2025-01-26T20:54:21.5031824+08:00:已释放
```

### 测试Scope场景

``` cangjie
let services = ServiceCollection()
services.addScoped<IDbContext, SqlDbContext>()
//创建根容器作用域
try (rootScope = services.createRootScope()) {
    //创建请请求作用域1
    try (requestScope1 = rootScope.services.createScope()) {
        //context3,context4都通过子容器创建
        let context1 = requestScope1.services.getOrThrow<IDbContext>()
        let context2 = requestScope1.services.getOrThrow<IDbContext>()
        println("requestScope1:context3:${context1}")
        println("requestScope1:context4:${context2}")
    }
    //创建请请求作用域2
    try (requestScope2 = rootScope.services.createScope()) {
        //context3,context4都通过子容器创建
        let context3 = requestScope2.services.getOrThrow<IDbContext>()
        let context4 = requestScope2.services.getOrThrow<IDbContext>()
        println("requestScope2:context3:${context3}")
        println("requestScope2:context4:${context4}")
    }
}
```

运行结果：一共创建了两个scope，同时也只创建了两个实例

> 1. 无法通过根容器解析非单列的服务，因为假设可以，意味着该实例的生命周期跟随根容器，而根容器的生命周期伴随着整个app
> 2. 数据库连接这种时候使用Scoped生命周期，数据库连接是稀缺资源

``` cmd
requestScope1:context3:Sql:2025-01-26T20:55:59.547437+08:00 
requestScope1:context4:Sql:2025-01-26T20:55:59.547437+08:00 
2025-01-26T20:55:59.547437+08:00:已释放
requestScope2:context3:Sql:2025-01-26T20:55:59.5483586+08:00
requestScope2:context4:Sql:2025-01-26T20:55:59.5483586+08:00
2025-01-26T20:55:59.5483586+08:00:已释放
```

### 测试瞬时场景

``` cangjie
let services = ServiceCollection()
services.addTransient<IDbContext, SqlDbContext>()
//创建根容器作用域
try (rootScope = services.createRootScope()) {
    //创建请请求作用域1
    try (requestScope1 = rootScope.services.createScope()) {
        //context3,context4都通过子容器创建
        let context1 = requestScope1.services.getOrThrow<IDbContext>()
        let context2 = requestScope1.services.getOrThrow<IDbContext>()
        println("requestScope1:context3:${context1}")
        println("requestScope1:context4:${context2}")
    }
    //创建请请求作用域2
    try (requestScope2 = rootScope.services.createScope()) {
        //context3,context4都通过子容器创建
        let context3 = requestScope2.services.getOrThrow<IDbContext>()
        let context4 = requestScope2.services.getOrThrow<IDbContext>()
        println("requestScope2:context3:${context3}")
        println("requestScope2:context4:${context4}")
    }
}
```

运行结果：可以发现解析四次，创建了四个实例

``` cmd
requestScope1:context3:Sql:2025-01-26T20:57:55.0648047+08:00
requestScope1:context4:Sql:2025-01-26T20:57:55.0649149+08:00
2025-01-26T20:57:55.0648047+08:00:已释放
2025-01-26T20:57:55.0649149+08:00:已释放
requestScope2:context3:Sql:2025-01-26T20:57:55.0657362+08:00
requestScope2:context4:Sql:2025-01-26T20:57:55.0657747+08:00
2025-01-26T20:57:55.0657362+08:00:已释放
2025-01-26T20:57:55.0657747+08:00:已释放
```

## 解析多实现

``` cangjie
let services = ServiceCollection()
//同一服务注册两个实现
services.addSingleton<IDbContext, SqlDbContext>()
services.addSingleton<IDbContext, MySqlDbContext>()
//创建根容器作用域
try (rootScope = services.createRoot()){
    let contexts = rootScope.services.getServices<IDbContext>()
    println(contexts |> collectArray)
}
return 0
```

运行结果:可以看到mysql，sql都被解析出来了，通用遵循上面的生命周期规则

``` cmd
[Sql:2025-01-25T17:42:04.2411296+08:00, MySql:2025-01-25T17:42:04.2412346+08:00]
2025-01-25T17:42:04.2411296+08:00:已释放
2025-01-25T17:42:04.2412346+08:00:已释放
```

## 解析容器本身

谁解析就返回谁，底层返回的就是this，这个非常有用，有时候我们需要在Controller获取一个服务提供者，就可以直接解析ServiceProvider

``` cangjie
let services = ServiceCollection()
//创建根容器作用域
try (rootScope = services.createRootScope()){
    //provider1是通过根容器解析的，那么它就是根容器
    let provider1 = rootScope.services.getOrThrow<ServiceProvider>()
    try (requestScope = rootScope.services.createScope()){
        //provider2是通过requestScope解析的，那么它就是requestScope关联的容器
        let provider2 = requestScope.services.getOrThrow<ServiceProvider>()
    }
}
```

## 解析未注入的服务

``` cangjie
let services = ServiceCollection()
services.addSingleton<DbConnection, DbConnection>()
//创建根容器作用域
try (rootScope = services.createRootScope()) {
    //DbContext并未在容器中注册，但是它又依赖了容器中的实例
    //还可以传递剩余参数来辅助ActivatorUtilties创建，按传递顺序，如果容器里没有，就按用户传递的args顺序查找
    let context = ActivatorUtilties.createInstance<DbContext>(rootScope.services, "asp")
}
```

## 工厂模式

可以通过工厂模式来告诉容器如何创建某个服务，还可以避免反射性能损失

``` cangjie
public class DbConnection {}

public class DbContext {
    public let _connect: DbConnection
    public init(name: String, connect: DbConnection) {
        _connect = connect
    }
}
```

## 宏+工厂模式

如果依赖项全部都在容器内有注册，或者无依赖项，那么可以通过宏来生成工厂函数，进而实现规避反射，这个@Inject宏很好实现

``` cangjie
@Inject
public class DbConnection {}

@Inject
public class DbContext {
    public let _connect: DbConnection
    public init(connect: DbConnection) {
        _connect = connect
    }
}
let services = ServiceCollection()
services.addSingleton<DbConnection>(DbConnection.apply)
services.addSingleton<DbContext>(DbContext.apply)
//创建根容器作用域
try (rootScope = services.createRoot()) {
    let context = rootScope.services.getOrThrow<DbContext>()
}
```

宏展开

```
/* ===== Emitted by MacroCall @Inject in main.cj:8:1 ===== */
/* 8.1 */public class DbConnection {
/* 8.2 */    static public func apply(sp: ServiceProvider) {
/* 8.3 */        DbConnection()
/* 8.4 */    }
/* 8.5 */}
/* 8.6 */
/* ===== End of the Emit ===== */

/* ===== Emitted by MacroCall @Inject in main.cj:11:1 ===== */
/* 11.1 */public class DbContext {
/* 11.2 */    public let _connect: DbConnection
/* 11.3 */    public init(connect: DbConnection) {
/* 11.4 */        _connect = connect
/* 11.5 */    }
/* 11.6 */    static public func apply(sp: ServiceProvider) {
/* 11.7 */        DbContext(sp.getOrThrow < DbConnection >())
/* 11.8 */    }
/* 11.9 */}
/* 11.10 */
/* ===== End of the Emit ===== */
```

## 循环依赖检测

``` cangjie
public class A {
    public init(c:B) {
        
    }
}

public class B {
    public init(c:C) {
        
    }
}

public class C {
    public init(a:A) {
        
    }
}
main() {
    let services = ServiceCollection()
    services.addSingleton<A,A>()
    services.addSingleton<B,B>()
    services.addSingleton<C,C>()
    let provider = services.buildServiceProvider()
    provider.getOrThrow<A>()
    return 0
}
```

运行结果：

``` cmd
An exception has occurred:
Exception: A circular dependency has been detected, with the following path: asp.B -> asp.C -> asp.A -> asp.B.
         at asp.extensions.injection.ServiceCallChain::checkCircularDependency(asp.extensions.injection::ServiceIdentifier)(E:\gitcode\asp\src\extensions\injection\ServiceCallChain.cj:16)   
         at asp.extensions.injection.ServiceProviderEngine::getOrDefault(std.reflect::TypeInfo)(E:\gitcode\asp\src\extensions\injection\ServiceProviderEngine.cj:33)
         at asp.extensions.injection.$BOX_R_ZN24asp.extensions.injection21ServiceProviderEngineE::getOrDefault(std.reflect::TypeInfo)(:0)
         at asp.extensions.injection.ActivatorUtilties::createInstance(std.reflect::TypeInfo, asp.extensions.injection::IServiceProvider, std.core::Array<...>)(E:\gitcode\asp\src\extensions\injection\ActivatorUtilities.cj:18)
```





