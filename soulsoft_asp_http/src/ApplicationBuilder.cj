package soulsoft_asp_http

import std.collection.*
import soulsoft_extensions_injection.*

public abstract class ApplicationBuilder {
    public prop applicationServices: IServiceProvider
    
    public prop properties: HashMap<String, Any>
    
    public func use(middleware: (RequestDelegate) -> RequestDelegate): This
    
    public func use(middleware: (HttpContext, () -> Unit) -> Unit): This {
        use {
            next => {
                context => middleware(context) {
                    next(context)
                }
            }
        }
        return this
    }

    public func use(middleware: (HttpContext, RequestDelegate) -> Unit): This {
        use {
            next => {
                context => middleware(context, next)
            }
        }
        return this
    }
   
    public func use(middleware: IMiddleware): This {
        use {
            context, next => middleware.invoke(context, next)
        }
    }

    public func use<TMiddleware>(args: Array<String>): This where TMiddleware <: IMiddleware {
        use(ActivatorUtilities.createInstance<TMiddleware>(applicationServices, args))
    }

    public func build(): RequestDelegate
}
