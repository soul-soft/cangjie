# soulsoft_web_staticfiles
用于处理和提供静态文件请求，比如HTML文件、图像、CSS样式表和JavaScript文件。

# 基本使用

``` cangjie
main() {
	let builder = WebHost.createBuilder()
    let host = builder.build()
    //使用欢迎页中间件：默认查找webContentRoot下面的默认文件
    host.useDefaultFiles()
    //使用静态文件中间件
    host.useStaticFiles()
    host.run()
	return 0
}
```

# 默认文件中间件

``` cangjie
host.useDefaultFiles{ configure =>
    //添加更多的欢迎页配置，默认支持的文件名称，请查看源码
    configure.defaultFileNames.add("welcome.html")
}
```

# 静态文件中间件

``` cangjie
host.useStaticFiles{ configureOptions =>
    //使用指定的内容映射器，如果默认的映射规则不存在，那么将返回4040
    let contentTypeProvder = ContentTypeProvider()
    contentTypeProvder.mappings[".bcmap"] = "application/octet-stream"
    configureOptions.contentTypeProvider = contentTypeProvder
}
```

或者设置默认的内容类型

``` cangjie
host.useStaticFiles{ configureOptions =>
    configureOptions.serveUnknownFileTypes = true
    configureOptions.defaultContentType = "application/octet-stream"
}
```
