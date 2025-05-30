package soulsoft_extensions_logging

import std.reflect.TypeInfo

class LoggerInformation {
    private let _logger: ILogger
    private let _category: String
    private let _minLevel: ?LogLevel
    private let _filter: ?LoggerFilter
    private let _providerName: String

    init(logger: ILogger, category: String, providerName: String, minLevel: ?LogLevel, filter: ?LoggerFilter) {
        _logger = logger
        _filter = filter
        _minLevel = minLevel
        _category = category
        _providerName = providerName
    }

    public prop logger: ILogger {
        get() {
            _logger
        }
    }

    public prop category: String {
        get() {
            _category
        }
    }

    public prop providerName: String {
        get() {
            _providerName
        }
    }

    public prop filter: ?LoggerFilter {
        get() {
            _filter
        }
    }

    public prop minLevel: ?LogLevel {
        get() {
            _minLevel
        }
    }

    public func isEnabled(logLevel: LogLevel): Bool {
        if (let Some(minLevel) <- _minLevel) {
            if (logLevel < minLevel) {
                return false
            }
        }
        
        if (let Some(filter) <- _filter) {
            return filter(_providerName, _category, logLevel)
        }

        return true
    }
}
