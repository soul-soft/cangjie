package aspire_net_http

import std.io.*
import std.collection.*

public class StreamContent <: HttpContent {
    private let _stream: InputStream

    public init(stream: InputStream) {
        _stream = stream
    }

    public func readAsStream(): InputStream {
        _stream
    }
}
