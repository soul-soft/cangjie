package aspire_web_staticfiles

import std.fs.{exists, File}

class DefaultFileMiddleware <: IMiddleware {
    private let _fileProvider: IFileProvider
    private let _options: DefaultFilesOptions
    private let _environment: IWebHostEnvironment

    init(options: DefaultFilesOptions, environment: IWebHostEnvironment) {
        _options = options
        _environment = environment
        _fileProvider = options.fileProvider ?? PhysicalFileProvider()
    }

    public func invoke(context: HttpContext, next: () -> Unit): Unit {
        if (context.request.path != "/") {
            next()
        }
        else if (!validateNoEndpointDelegate(context)) {
            next()
        } else if (!validateRequestMethod(context)) {
            next()
        } else if(let Some(fileInfo) <- getFileInfo()) {
            let content = StaticFileContent(fileInfo, "text/html")
            content.serve(context)
        }else {
            next()
        }
    }

    private func validateNoEndpointDelegate(context: HttpContext) {
        context.getEndpoint().isNone()
    }

    private func validateRequestMethod(context: HttpContext) {
        Helpers.isGetOrHeadMethod(context.request.method)
    }

    private func getFileInfo(): ?IFileInfo {
        let subpath = if (let Some(requestPath) <- _options.requestPath) {
            "${_environment.webRootPath}${requestPath}"
        }else {
            "${_environment.webRootPath}/"
        }
         for (defaultFile in _options.defaultFileNames) {
            let fileInfo = _fileProvider.getFileInfo("${subpath}${defaultFile}")
            if (fileInfo.exists) {
               return fileInfo
            }
        }
        return None
    }
}
