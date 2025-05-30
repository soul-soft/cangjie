package soulsoft_asp_routing

import std.collection.*

public class EndpointMiddleware <: IMiddleware {
    public func invoke(context: HttpContext, next: () -> Unit): Unit {
        if (let Some(endpoint) <- context.getEndpoint()) {
            endpoint.delegate(context)
        } else {
            next()
        }
    }

   
}
