package soulsoft_web_staticfiles

import soulsoft_extensions_injection.*

public interface DefaultFileExtensions {
    func useDefaultFiles(): Unit
}

extend ApplicationBuilder <: DefaultFileExtensions {
    public func useDefaultFiles(): Unit {
        let environment = this.applicationServices.getOrThrow<IWebHostEnvironment>()
        use(DefaultFileMiddleware(environment))
    }
}