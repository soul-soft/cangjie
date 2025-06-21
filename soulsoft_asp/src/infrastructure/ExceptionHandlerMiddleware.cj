package soulsoft_asp.infrastructure

import soulsoft_asp_http.*
import soulsoft_extensions_logging.*

public class ExceptionHandlerMiddleware <: IMiddleware {
    private let _logger: ILogger

    public init(logFactory: ILoggerFactory) {
        _logger = logFactory.createLogger<ExceptionHandlerMiddleware>()
    }

    public func invoke(context: HttpContext, next: () -> Unit): Unit {
        try {
            next()
        } catch (ex: Exception) {
            _logger.error(ex.message)
            ex.printStackTrace()
            context.response.status(HttpStatusCode.InternalServerError)
        }
    }
}
