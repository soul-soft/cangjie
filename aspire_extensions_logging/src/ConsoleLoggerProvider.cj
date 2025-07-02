/*
颜色实现原理参考了此库：https://gitcode.com/elon_tang/colored/blob/main/src/colored.cj
 */

package aspire_extensions_logging

import std.console.Console

class ConsoleLogger <: ILogger {
    private let _categoryName: String

    init(categoryName: String) {
        _categoryName = categoryName
    }

    public func log(logLevel: LogLevel, message: String, exception: ?Exception): Unit {
        println("${coloredAnsi(logLevel)}: ${_categoryName}")
        if (let Some(err) <- exception) {
            err.printStackTrace()
        } else {
            println("      ${message}")
        }
    }

    // 定义 colored 函数
    private func coloredAnsi(logLevel: LogLevel): String {
        let color = match (logLevel) {
            case LogLevel.Trace => "\u{1b}[90m" // 灰色
            case LogLevel.Debug => "\u{1b}[36m" // 青色
            case LogLevel.Info => "\u{1b}[32m" // 绿色
            case LogLevel.Warn => "\u{1b}[33m" // 黄色
            case LogLevel.Error => "\u{1b}[31m" // 红色
            case LogLevel.Fatal => "\u{1b}[91m" // 明亮红色
            case LogLevel.Off => "\u{1b}[90m" // 灰色
        }
        let reset = "\u{1b}[0m" // 重置颜色
        return "${color}${logLevel}${reset}" // 返回带颜色和重置序列的字符串
    }
}

class ConsoleLoggerProvider <: ILoggerProvider {
    public prop name: String {
        get() {
            "console"
        }
    }

    public func createLogger(categoryName: String): ILogger {
        return ConsoleLogger(categoryName)
    }
}

extend LoggingBuilder{
    public func addConsole() {
        addProvider(ConsoleLoggerProvider())
        return this
    }
}