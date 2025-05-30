# soulsoft_extensions_hosting

通用主机（Generic Host） 库，能够用来创建后台服务、控制台应用、Web 应用等，并提供了依赖注入、日志、配置管理、生命周期管理等功能。

# dependencies

[soulsoft_extensions_logging](https://gitcode.com/soulsoft/soulsoft_extensions_logging.git)  
[soulsoft_extensions_options](https://gitcode.com/soulsoft/soulsoft_extensions_options.git)  
[soulsoft_extensions_injection](https://gitcode.com/soulsoft/soulsoft_extensions_injection.git)  
[soulsoft_extensions_configuration](https://gitcode.com/soulsoft/soulsoft_extensions_configuration.git)

# quickstart

由于hosting整合了日志，选项，注入，配置，因此你需要分别学习这些模块，每个模块下都有对应文档，这里不做演示。

## BackgroundService
使用后台服务可以用来执行windows程序，处理消息队列，定时服务等
``` cangjie
package soulsoft_extensions_hosting

import soulsoft_extensions_options.*

main() {
    let builder = Host.createBuilder()
    builder.services.addTestHostedService({_=>})
    builder.services.configure<TestHostedServiceOptions>{ configureOptions =>
        configureOptions.delay = 10
    }
    let host = builder.build()
    host.run()
    return 0
}

/**这是aspnetcore基本套路，注入、选项、扩展**/
public interface TestHostedServiceExtensions {
    func addTestHostedService(configure: (TestHostedServiceOptions) -> Unit): ServiceCollection
}

extend ServiceCollection {
    public func addTestHostedService(configure: (TestHostedServiceOptions) -> Unit): ServiceCollection {
        this.addHostedService<TestHostedService>()
        this.configure<TestHostedServiceOptions>(configure)
        return this
    }
}

public class TestHostedServiceOptions {
    public var delay = 1
}

public class TestHostedService <: BackgroundService {
    private let _options: IOptions<TestHostedServiceOptions>

    public init(options: IOptions<TestHostedServiceOptions>) {
        _options = options
    }

    public func run() {
        println("delay:${_options.value.delay}")
        while (!Thread.currentThread.hasPendingCancellation) {
            println("do something ...")
            sleep(Duration.second * _options.value.delay)
        }
    }
}

```

## Lifetime

``` cangjie
main() {
    let builder = Host.createBuilder(args)
    let host = builder.build()
    host.lifetime.onStarted{
        //资源加载
    }
    host.lifetime.onStopped{
        //资源销毁
    }
    host.run()
    return 0
}
```
