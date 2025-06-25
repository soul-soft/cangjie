package soulsoft_identity_protocols

import std.io.*
import std.fs.*

public class FileDocumentRetriever <: IDocumentRetriever {
    public func getDocument(address: String) {
        return StringReader(File(address, OpenMode.Read)).readToEnd()
    }
}
