package soulsoft_asp_staticfiles

import std.fs.{exists, File}

class StaticFileMiddleware <: IMiddleware {
    private let _environment: IWebHostEnvironment

    init(environment: IWebHostEnvironment) {
        _environment = environment
    }

    public func invoke(context: HttpContext, next: () -> Unit): Unit {
        let path = context.request.path.value
        let file = "${_environment.webRootPath}${path}"
        if (path != "/" && exists(file)) {
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
}
