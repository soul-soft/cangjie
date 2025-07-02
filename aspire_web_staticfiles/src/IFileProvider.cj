package aspire_web_staticfiles

import std.io.*

public interface IFileProvider {
    func getFileInfo(path: String): IFileInfo
}