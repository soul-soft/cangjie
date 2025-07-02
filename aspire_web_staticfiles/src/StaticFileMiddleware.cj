package aspire_web_staticfiles

import std.io.*
import std.fs.*
import std.convert.*

class StaticFileMiddleware <: IMiddleware {
    private let _options: StaticFileOptions
    private let _fileProvider: IFileProvider
    private let _environment: IWebHostEnvironment
    private let _contentTypeProvider: IContentTypeProvider

    init(options: StaticFileOptions, environment: IWebHostEnvironment) {
        _options = options
        _environment = environment
        _fileProvider = options.fileProvider ?? PhysicalFileProvider()
        _contentTypeProvider = options.contentTypeProvider ?? ContentTypeProvider()
    }

    public func invoke(context: HttpContext, next: () -> Unit): Unit {
       
        if (!validateNoEndpointDelegate(context)) {
            next()
        } else if (!validateRequestMethod(context)) {
            next()
        } else if((let Some(contentType) <- validateContentType(context.request.path.value))) {
            let fileInfo = getFileInfo(context)
            let content = StaticFileContent(fileInfo, contentType)
            if (fileInfo.exists) {
                content.serve(context)
            }else {
                next()
            }
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

    private func validateContentType(path: String): ?String {
        if (let Some(contentType) <- _contentTypeProvider.getContentType(path)) {
            return contentType
        }

        if (_options.serveUnknownFileTypes && (let Some(contentType) <- _options.defaultContentType)) {
            return contentType
        }

        return None
    }

    private func getFileInfo(context: HttpContext) {
        let subpath = if (let Some(requestPath) <- _options.requestPath) {
            "${_environment.webRootPath}${requestPath}${context.request.path.value}"
        }else {
            "${_environment.webRootPath}${context.request.path.value}"
        }

        return _fileProvider.getFileInfo(subpath)
    }
}
