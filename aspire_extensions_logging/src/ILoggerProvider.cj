package aspire_extensions_logging

public interface ILoggerProvider {
    prop name:String
    func createLogger(category:String): ILogger
}
