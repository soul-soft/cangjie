package soulsoft_asp.infrastructure

import std.collection.*
import soulsoft_asp_http.*
import soulsoft_asp_routing.*
import soulsoft_asp_mvc.abstractions.*

/*
用于生成请求接口（简易版）
 */
public class OpenApiMiddleware <: IMiddleware {
    private let _dataSource: EndpointDataSource

    public init(dataSource: EndpointDataSource) {
        _dataSource = dataSource
    }

    public func invoke(context: HttpContext, next: () -> Unit): Unit {
        if (context.request.path.value == "/openapi") {
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
