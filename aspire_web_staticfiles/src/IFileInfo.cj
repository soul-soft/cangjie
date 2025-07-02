package aspire_web_staticfiles

import std.io.*
import std.time.*

public interface IFileInfo {    
    prop name: String
    prop size: Int64
    prop exists: Bool
    prop isDirectory: Bool
    prop physicalPath: ?String
    prop lastModified: DateTime
    func createReadStream(): InputStream
}