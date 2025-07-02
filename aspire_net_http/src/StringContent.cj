package aspire_net_http

import std.io.*

public class StringContent <: ByteArrayContent {

    public init(content: String) {
        this(content, "text/plain", "utf-8")
    }

    public init(content: String, mediaType: String) {
        this(content, mediaType, "utf-8")
    }

    public init(content: String, mediaType: String, encoding: String) {
        super(content.toArray())
        headers.add("Content-Type", "${mediaType}; charset=${encoding}")
    }
}
