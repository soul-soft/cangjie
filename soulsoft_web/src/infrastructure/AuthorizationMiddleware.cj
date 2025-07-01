package soulsoft_web.infrastructure

import std.collection.*
import soulsoft_web_http.*
import soulsoft_web_routing.*
import soulsoft_security_claims.*
import soulsoft_web_authentication.*
import soulsoft_extensions_logging.*

/**
授权中间件: 简化版，用于展示soulsoft_web_authorization内部逻辑
*/
public class AuthorizationMiddleware <: IMiddleware {
    private let logger: ILogger

    public init(logFactory: ILoggerFactory) {
        logger = logFactory.createLogger<AuthorizationMiddleware>()
    }

    public func invoke(context: HttpContext, next: () -> Unit) {
        if (let Some(endpoint) <- context.getEndpoint()) {
            if (endpoint.metadata.getMetadata<IAuthorizeData>().isSome() && !(endpoint.metadata |> any{f => f is IAllowAnonymous})) {
                logger.info("${context.request.getDisplayUrl()}:需要认证")
                if (!context.authenticate().succeeded) {
                    logger.info("${context.request.getDisplayUrl()}:认证失败,发起challenge")
                    //短路
                    context.challenge()
                    return
                } else {
                    let username = context.user.findFirstValue("username")
                    logger.info("${context.request.getDisplayUrl()}:认证成功,username:${username}")
                }
            } else {
                logger.info("${context.request.getDisplayUrl()}:无须认证")
            }
        }
        next()
    }
}