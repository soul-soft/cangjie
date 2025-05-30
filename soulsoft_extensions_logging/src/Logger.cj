package soulsoft_extensions_logging

import std.collection

class Logger <: ILogger {
    private let _loggers: Collection<LoggerInformation>

    init(loggers: Collection<LoggerInformation>) {
        _loggers = loggers
    }

    public func isEnabled(logLevel: LogLevel) {
        for (pattern in _loggers) {
            if (pattern.isEnabled(logLevel)) {
                return true
            }
        }
        return false
    }

    public func log(logLevel: LogLevel, message: String, exception: ?Exception): Unit {
        for (logInfo in _loggers) {
            if (!logInfo.isEnabled(logLevel)) {
                continue
            }
            logInfo.logger.log(logLevel, message, exception)
        }
    }
}
