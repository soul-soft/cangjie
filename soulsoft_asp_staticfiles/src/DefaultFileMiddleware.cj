package soulsoft_asp_staticfiles

import std.fs.{exists, File}

class DefaultFileMiddleware <: IMiddleware {
    private let _fileNmaes: Array<String> = ["index.html", "index.htm", "default.html", "default.htm"]
    private let _environment: IWebHostEnvironment

    public init(environment: IWebHostEnvironment) {
        _environment = environment
    }

    public func invoke(context: HttpContext, next: () -> Unit): Unit {
        let webRootPath = _environment.webRootPath
        if (context.request.url.path == "/" && let Some(file) <- findFile(webRootPath)) {
            let bytes = File.readFrom(file)
            context.response.write(bytes)
            context.response.status(200)
            context.response.addHeader("Cache-Control", "public, max-age=3600")
            if (let Some(contentType) <- StaticFileMineTypes.parse(file)) {
                context.response.addHeader("content-type", contentType)
            }
        } else {
            next()
        }
    }

    private func findFile(webRootPath: String): ?String {
        for (fileName in _fileNmaes) {
            let file = "${webRootPath}/${fileName}"
            if (exists(file)) {
                return file
            }
        }
        None
    }

}
