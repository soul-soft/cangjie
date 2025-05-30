package soulsoft_extensions_logging

import std.time.DateTime
import std.fs.{exists, File, Directory}

class FileLogger <: ILogger {
    private let _categoryName: String

    init(categoryName: String) {
        _categoryName = categoryName
    }

    public func log(logLevel: LogLevel, message: String, _: ?Exception): Unit {
        let path = "./logs"
        if (!exists(path)) {
            Directory.create(path, recursive: true)
        }
        let filePath = "${path}/${DateTime.now().format("yyyyMMdd")}.log"
        let messageFormated = "${logLevel}: ${DateTime.now().format("yyyy-MM-dd HH:mm:ss")}, ${_categoryName}\r\n\t${message}\r\n"
        File.appendTo(filePath, messageFormated.toArray())
    }
}

class FileLoggerProvider <: ILoggerProvider {
     
    public prop name:String {
        get() {
            "file"
        }
    }

    public func createLogger(categoryName: String): ILogger {
        return FileLogger(categoryName)
    }
}
