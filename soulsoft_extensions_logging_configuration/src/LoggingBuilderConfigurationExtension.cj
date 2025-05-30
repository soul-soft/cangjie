package soulsoft_extensions_logging_configuration

import soulsoft_extensions_logging.*
import soulsoft_extensions_configuration.*

public interface LoggingBuilderConfigurationExtension {
    func addConfiguration(configuration: IConfiguration): LoggingBuilder
}

extend LoggingBuilder <: LoggingBuilderConfigurationExtension {
    
    public func addConfiguration(configuration: IConfiguration): LoggingBuilder {
        for (pattern in configuration.getChildren()) {
            if (pattern.key == "logLevel") {
                loadRules(None, pattern)
            } else {
                loadRules(pattern.key, pattern.getSection("logLevel"))
            }
        }
        return this
    }

    private func loadRules(providerName: ?String, section: IConfiguration) {
        for (pattern in section.getChildren()) {
            var categoryName: ?String = pattern.key
            if (categoryName == "default") {
                categoryName = None
            }
            let logLevel = parseLogLevel(pattern.value)
            this.addFilter(providerName, categoryName, logLevel)
        }
    }

    private func parseLogLevel(level: ?String) {
        return match (level) {
            case Some("Trace") => LogLevel.Trace
            case Some("Debug") => LogLevel.Debug
            case Some("Info") => LogLevel.Info
            case Some("Warn") => LogLevel.Warn
            case Some("Error") => LogLevel.Error
            case Some("Fatal") => LogLevel.Fatal
            case Some("Off") => LogLevel.Off
            case f => throw UnsupportedException(level.toString())
        }
    }
}
