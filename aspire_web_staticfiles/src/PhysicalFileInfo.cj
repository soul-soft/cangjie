package aspire_web_staticfiles

import std.io.*
import std.fs.*
import std.time.*

public class PhysicalFileInfo <: IFileInfo {
    private let _info: FileInfo
    
    public init(info: FileInfo) {
        _info = info
    }
    
    public prop name: String {
        get() {
            _info.name
        }
    }

    public prop size: Int64 {
        get() {
            _info.size
        }
    }

    public prop exists: Bool {
        get() {
            true
        }
    }

    public prop isDirectory: Bool {
        get() {
            _info.isDirectory()
        }
    }

    public prop physicalPath: ?String {
        get() {
            _info.path.toString()
        }
    }

    public prop lastModified: DateTime {
        get() {
            _info.lastModificationTime
        }
    }

    public func createReadStream(): InputStream {
        File(_info.path, OpenMode.Read)
    }
}