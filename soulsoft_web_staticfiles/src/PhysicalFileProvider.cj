package soulsoft_web_staticfiles

import std.fs.*

public class PhysicalFileProvider <: IFileProvider {
    public func getFileInfo(path: String): IFileInfo {
        if (exists(path)) {
            return PhysicalFileInfo(FileInfo(path))
        }else {
            return NotFoundFileInfo(path)
        }
    }
}