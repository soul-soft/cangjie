package soulsoft_extensions_logging

public class LoggerFilterOptions {
    private let _minLevel: LogLevel
    private let _rules: Collection<LoggerFilterRule>

    init(minLogLevel: LogLevel, rules: Collection<LoggerFilterRule>) {
        _minLevel = minLogLevel
        _rules = rules
    }

    public prop minLevel: LogLevel {
        get() {
            _minLevel
        }
    }

    public prop rules: Collection<LoggerFilterRule> {
        get() {
            _rules
        }
    }
}
