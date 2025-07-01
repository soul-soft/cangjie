package soulsoft_web_quickstart.services

import soulsoft_web_http.*
import soulsoft_extensions_logging.*

//ioc容器会自动管理资源
public class EntityService <: Resource {
    private let _logger: ILogger
    private var _isClosed = false

    public EntityService(let _logFactory: ILoggerFactory, let _contextAccessor: IHttpContextAccessor) {
        _logger = _logFactory.createLogger<EntityService>()
    }

    public func working() {
        //业务层也可以获取httpContext，方便进行单元测试，单元测试你可以实现IHttpContextAccessor,并注入容器
        let context = _contextAccessor.context.getOrThrow {=> Exception("not http")}
        _logger.info(context.request.getDisplayUrl())
    }

    public func isClosed() {
        return _isClosed
    }

    public func close() {
        if (isClosed()) {
            return
        }
        _isClosed = true
        _logger.info("closed")
    }
}
