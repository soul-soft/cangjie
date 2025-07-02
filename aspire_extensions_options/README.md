# aspire_extensions_options
选项配置（Options）库。它提供了统一的、类型安全的、规范的方式来配置应用程序，并且支持多架构多租户。

# dependencies
[aspire_extensions_injection](https://gitcode.com/aspire/aspire_extensions_injection.git)

# quickstart

``` cangjie
public class AppOptions {
   var name = ""
   var version = ""
}
let services = ServiceCollection()

//configureAfter：在所有的configure之后执行，你可以添加println来观察执行顺序
services.configureAfter<CorsOptions>({configureOptions => 
    configureOptions.name = "aspire"
    configureOptions.version = "0.58.4"
})

services.configure<CorsOptions>({configureOptions => 
    configureOptions.name = "aspire"
    configureOptions.version = "0.58.3"
})

services.configure<CorsOptions>("asp", {configureOptions => 
    configureOptions.name = "aspire"
    configureOptions.version = "0.58.1"
})

services.configure<CorsOptions>("cjc", {configureOptions => 
    configureOptions.name = "aspire"
    configureOptions.version = "0.58.3"
})

let provider = services.buildProdiverService()
let options = provider.getOrThrow<IOption<AppOptions>>()
let defaultOption = options.value
let aspOptions = options.get("asp")
let cjcOptions = options.get("cjc")
```