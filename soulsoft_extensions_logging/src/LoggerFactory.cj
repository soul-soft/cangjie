package soulsoft_extensions_logging

import std.sync.*
import std.console.Console
import std.reflect.TypeInfo
import std.collection.*

public class LoggerFactory <: ILoggerFactory{
    private let _lock = Mutex()
    private let _options: LoggerFilterOptions
    private let _loggers = HashMap<String, ILogger>()
    private let _providers: Collection<ILoggerProvider>

    internal init(providers: Collection<ILoggerProvider>, options: LoggerFilterOptions) {
        _options = options
        _providers = providers
    }

    public func createLogger(categoryName: String): ILogger {
        if (_loggers.contains(categoryName)) {
            return _loggers[categoryName]
        }
        synchronized(_lock) {
            if (_loggers.contains(categoryName)) {
                return _loggers[categoryName]
            }
            let loggers = createLoggers(categoryName)
            return Logger(loggers)
        }
    }

    private func createLoggers(categoryName: String) {       
        let list = ArrayList<LoggerInformation>()
        for (provider in _providers) {
            let logger = provider.createLogger(categoryName)
            let (minLevel, filter) = LoggerRuleSelector.select(_options, provider.name, categoryName)
            list.add(LoggerInformation(logger, categoryName, provider.name, minLevel, filter))
        }
        return list
    }

    public static func create(configure: (LoggingBuilder) -> Unit): ILoggerFactory {
        let builder = LoggingBuilder()
        configure(builder)
        return builder.build()
    }
}
