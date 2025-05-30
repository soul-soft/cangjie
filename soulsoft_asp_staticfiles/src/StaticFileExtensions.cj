package soulsoft_asp_staticfiles

import soulsoft_extensions_injection.*

public interface StaticFileExtensions {
    func useStaticFiles(): Unit
}

extend ApplicationBuilder <: StaticFileExtensions {
    public func useStaticFiles(): Unit {
        let environment = this.applicationServices.getOrThrow<IWebHostEnvironment>()
        use(StaticFileMiddleware(environment))
    }
}
