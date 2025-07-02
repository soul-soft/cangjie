package aspire_extensions_logging

import std.reflect.*

public interface ILoggerFactory {
    func createLogger<T>(): ILogger {
        createLogger(TypeInfo.of<T>().qualifiedName)
    }
    
    func createLogger(categoryName: String): ILogger
}