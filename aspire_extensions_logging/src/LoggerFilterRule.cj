package aspire_extensions_logging

public class LoggerFilterRule <: ToString {
    private let _providerName: ?String
    private let _categoryName: ?String
    private let _logLevel: ?LogLevel
    private let _filter: ?LoggerFilter

    public init(providerName:? String, categoryName: ?String, logLevel: LogLevel) {
        this(providerName, categoryName, logLevel, None)
    }

    public init(filter: ?LoggerFilter) {
        this(None, None, None, filter)
    }

    private init(providerName: ?String, categoryName: ?String, logLevel: ?LogLevel, filter: ?LoggerFilter) {
        _providerName = providerName
        _categoryName = categoryName
        _logLevel = logLevel
        _filter = filter
    }

    public prop filter: ?LoggerFilter {
        get() {
            _filter
        }
    }

    public prop logLevel: ?LogLevel {
        get() {
            _logLevel
        }
    }

    public prop categoryName: ?String {
        get() {
            _categoryName
        }
    }

    public prop providerName: ?String {
        get() {
            _providerName
        }
    }

    public func toString() {
        return "providerName: '${providerName}', categoryName: '${categoryName}', logLevel: '${logLevel}', filter: '${filter.isNone()}'";
    }
}
