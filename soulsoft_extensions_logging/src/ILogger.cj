package soulsoft_extensions_logging

public interface ILogger {
    func log(logLevel: LogLevel, message: String, exception: ?Exception): Unit
    func isEnabled(logLevel: LogLevel): Bool {
        return logLevel != LogLevel.Off
    }
    func trace(message: String) {
        log(LogLevel.Trace, message, None)
    }
    func debug(message: String) {
        log(LogLevel.Debug, message, None)
    }
    func info(message: String) {
        log(LogLevel.Info, message, None)
    }
    func warn(message: String) {
        log(LogLevel.Warn, message, None)
    }
    func error(message: String) {
        log(LogLevel.Error, message, None)
    }
    func error(exception: Exception, message: String) {
        log(LogLevel.Error, message, exception)
    }
    func fatal(message: String) {
        log(LogLevel.Fatal, message, None)
    }
}
