package soulsoft_asp

import std.time.*
import std.random.*
import std.reflect.*
import std.collection.*
//asp
import soulsoft_asp.services.*
import soulsoft_asp.controllers.*
import soulsoft_asp.hostservices.*
import soulsoft_asp.infrastructure.*
import soulsoft_asp.authentication.*

main(args: Array<String>): Int64 {
    let builder = WebHost.createBuilder(args)
    //==============服务注册==================

    builder.services.addControllers()
        //由于目前没法实现自动扫描，因此需要手动注册
        .addApplicationPart("default", TypeInfo.of<EntityController>())

    //运行一个测试的后台服务
    //builder.services.addHelloHostedService()

    //将httpContext访问器注入容器
    builder.services.addHttpContextAccessor()

    //注册一个自定义请求服务
    builder.services.addTransient<EntityService, EntityService>()

    //注册资源所有者验证器
    builder.services.addTransient<IResourceOwnerPasswordValidator, ResourceOwnerPasswordValidator>()

    //注册身份认证方案
    builder
        .services
        .addAuthentication(JwtBearerAuthenticationDefaults.Scheme)
        //注册basic认证方案
        .addScheme<BasicAuthenticationOptions, BasicAuthenticationHandler>(BasicAuthenticationDefault.Scheme)
        //注册jwtBearer认证方案
        .addJwtBearer(JwtBearerAuthenticationDefaults.Scheme) { configureOptions =>
            let secret = builder.configuration["authentication:securityKey"].getOrThrow().toArray()
            let securityKey = SymmetricSecurityKey(secret)
            configureOptions.tokenValidationParameters.validIssuer = "soulsoft"
            configureOptions.tokenValidationParameters.validateAudience = false
            configureOptions.tokenValidationParameters.issuerSigningKey = securityKey
        }

    //注册授权服务
    builder
        .services
        .addAuthorizationBuilder()
        .addPolicy("default") {
            policy =>
            //必须包含username
            policy.requireClaim("username")
            //基本要求，具体参考源码
            policy.requireAuthenticatedUser()
        }

    //注册健康检查项
    builder
        .services
        .addHealthChecks()
        .addCheck("self") {
            //模拟随机不健康效果
            let random = Random()
            if (random.nextInt32(10) % 2 == 0) {
                HealthCheckResult.healthy()
            } else {
                HealthCheckResult.unhealthy()
            }
        }

    //==============请求管道==================    
    let host = builder.build()

    //异常处理
    host.use<ExceptionHandlerMiddleware>()

    //接口文档
    host.use<OpenApiMiddleware>() ///openapi

    //注册健康检查
    host.useHealthChecks("/health")

    //默认静态资源
    host.useDefaultFiles()

    //静态资源
    host.useStaticFiles()

    //使用身份认证
    host.useAuthentication()

    //动态资源路由（负责路由，并放到HttpContext上）
    host.useRouting()

    //由于该中间件需要使用路由到的endpoint，因此必须放到useRouting后面
    host.useAuthorization()

    //动态资源(负责注册和执行)
    host.useEndpoints {
        endpoints =>
        endpoints.mapGet("connect/token") {
            context =>
            let securityKey = SymmetricSecurityKey(
                host.configuration["authentication:securityKey"].getOrThrow().toArray())
            let jwtHeader = JwtHeader(SigningCredentials(securityKey, SecurityAlgorithms.HmacSha256))
            let jwtPayload = JwtPayload(issuer: "soulsoft", notBefore: DateTime.now(), expires: DateTime.now(),
                claims: [("sub", "1024"), ("username", "cangjie")])

            let jwtTokenHander = JwtSecurityTokenHandler()
            let accessToken = jwtTokenHander.writeToken(JwtSecurityToken(jwtHeader, jwtPayload))
            context.response.write(accessToken)
        }
        //登入接口需要授权
        endpoints
            .mapGet("connect/logout") {
                context => context.response.write("logout succeeded")
            }
            .requireAuthorization("default")

        //无须授权
        endpoints.mapGet("hello") {
            context => context.response.write("hello:soulsoft")
        }

        endpoints.mapControllers()
            //所有的action需要授权
            .requireAuthorization("default")
    }
    host.run()
    return 0
}
