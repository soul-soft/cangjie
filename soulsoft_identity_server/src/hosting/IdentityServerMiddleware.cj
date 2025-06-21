package soulsoft_identity_server.hosting

import soulsoft_asp_http.*

public class IdentityServerMiddleware <: IMiddleware {
    private let _router: IEndpointRouter

    public init(router: IEndpointRouter) {
        _router = router    
    }

    public func invoke(context: HttpContext, next: () -> Unit) {
        if (let Some(handler) <- _router.routing(context)) {
            let result = handler.handle(context)
            result.execute(context)
        }else {
            next()
        }
    }
}
