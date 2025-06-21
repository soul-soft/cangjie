# soulsoft_net_http

提供用于处理基于 HTTP（或 HTTPS）协议网络通信的库。它包含了处理 HTTP 请求与响应所需的类和工具，最常用的核心类是 HttpClient，并且提供aop能力的支持

# dependencies

无

# quickstart

```cangjie
package soulsoft_net_http

import encoding.url.*

main(): Int64 {
    let client = HttpClient({options => 
        options.address = URL.parse("https://localhost:7053")
        options.handlers.add(LoggingHandlerV1())
        options.handlers.add(LoggingHandlerV2())
    })
    let request = HttpRequestMessage(HttpMethod.get, "/WeatherForecast")
    request.content = FormUrlContent([("name", "zs")])
    let response = client.send(request)
    println(response.content.readAsString())
    return 0
}

/**
切面1：模拟身份认证
*/
public class LoggingHandlerV1 <: IHttpMessageHandler {
    public func send(request: HttpRequestMessage, next: DelegatingHandler): HttpResponseMessage {
        println("LoggingHandlerV1:start")
        let response = next(request)
        println("LoggingHandlerV1:end")
        return response
    }
}

/**
切面2：模拟日志记录
*/
public class LoggingHandlerV2 <: IHttpMessageHandler {
    public func send(request: HttpRequestMessage, next: DelegatingHandler): HttpResponseMessage {
        println("LoggingHandlerV2:start")
        let response = next(request)
        println("LoggingHandlerV2:end")
        return response
    }
}
```

# multipart/form-data

``` cangjie
let content = MultipartFormDataContent()
content.add(StringContent("ff1"), "P1")
content.add(StringContent("ff1"), "P2")
content.add(ByteArrayContent("ff".toArray()), "P3", "ff.txt")
let client = HttpClient()
client.address = URL.parse("https://localhost:7064")
client.post("/upload", content)
```