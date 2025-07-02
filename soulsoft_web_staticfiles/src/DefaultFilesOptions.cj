package soulsoft_web_staticfiles

import std.collection.*

public class DefaultFilesOptions <: SharedOptionsBase {
    public let _defaultFileNames: List<String>

    public init() {
        _defaultFileNames = ArrayList<String>(["index.html", "default.html", "default.htm",  "index.htm"])
    }

    public prop defaultFileNames: List<String> {
        get() {
            _defaultFileNames
        }
    }
}
