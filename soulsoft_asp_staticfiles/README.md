# soulsoft_asp_staticfiles
用于处理和提供静态文件请求，比如HTML文件、图像、CSS样式表和JavaScript文件。这个组件通过简单的配置即可集成到ASP.NET Core应用中，允许开发者为客户端提供站点所需的各种静态资源。

# dependencies
[soulsoft_asp_http](https://gitcode.com/soulsoft/soulsoft_asp_http.git)  
[soulsoft_asp_hosting](https://gitcode.com/soulsoft/soulsoft_asp_hosting.git)  
[soulsoft_extensions_injection](https://gitcode.com/soulsoft/soulsoft_extensions_injection.git)  

# quickstart

``` cangjie
main() {
	let builder = WebHost.createBuilder()
    let host = builder.build()
    host.useDefaultFiles()
    host.useStaticFiles()
	return 0
}
```
