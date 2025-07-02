package soulsoft_web_staticfiles

import std.io.*
import std.time.*

public class NotFoundFileInfo <: IFileInfo {
    private let _name: String

    public init(name: String) {
        _name = name
    }

    public prop name: String {
        get() {
            _name
        }
    }

    public prop size: Int64 {
        get() {
            -1
        }
    }

    public prop exists: Bool {
        get() {
            false
        }
    }

    public prop isDirectory: Bool {
        get() {
            false
        }
    }

    public prop physicalPath: ?String {
        get() {
            None
        }
    }

    public prop lastModified: DateTime {
        get() {
            return DateTime.of(year: 1970, month: 1, dayOfMonth: 1)
        }
    }

    public func createReadStream(): InputStream {
        throw IOException()
    }
}
