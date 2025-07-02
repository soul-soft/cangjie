package aspire_extensions_logging

type LoggerFilter = (providerName: String, categoryName: String, level: LogLevel) -> Bool