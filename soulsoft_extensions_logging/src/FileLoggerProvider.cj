package soulsoft_extensions_logging

import std.time.{DateTime}
import std.collection.concurrent.*
import std.fs.{exists, File, Directory}

class FileLogger <: ILogger {
    private let _categoryName: String
    private let _queue : ConcurrentLinkedQueue<LogEntry>

    init(categoryName: String, queue:  ConcurrentLinkedQueue<LogEntry>) {
        _categoryName = categoryName
        _queue = queue
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
    private let _queue = ConcurrentLinkedQueue<LogEntry>()

    public prop name: String {
        get() {
            "file"
        }
    }

    public func createLogger(categoryName: String): ILogger {
        return FileLogger(categoryName, _queue)
    }

    public func subscribe() {
        // spawn {
           
        // }
    }
}

extend LoggingBuilder{
      public func addFile() {
        let provider = FileLoggerProvider()
        provider.subscribe()
        addProvider(provider)
        return this
    }
}

struct LogEntry {
    LogEntry(let logLevel: LogLevel, let message: String, let ex: Exception) {
    }
}
