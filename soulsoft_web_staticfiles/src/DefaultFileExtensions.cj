package soulsoft_web_staticfiles

import soulsoft_extensions_injection.*

public interface DefaultFileExtensions {
    func useDefaultFiles(): Unit
    func useDefaultFiles(options: DefaultFilesOptions): Unit
    func useDefaultFiles(configureOptions: (DefaultFilesOptions) -> Unit): Unit
}

extend ApplicationBuilder <: DefaultFileExtensions {
    public func useDefaultFiles(): Unit {
        let options = DefaultFilesOptions()
        useDefaultFiles(options)
    }

    public func useDefaultFiles(configureOptions: (DefaultFilesOptions) -> Unit): Unit {
        let options = DefaultFilesOptions()
        configureOptions(options)
        useDefaultFiles(options)
    }

    public func useDefaultFiles(options: DefaultFilesOptions): Unit {
        let environment = this.applicationServices.getOrThrow<IWebHostEnvironment>()
        use(DefaultFileMiddleware(options, environment))
    }
}
