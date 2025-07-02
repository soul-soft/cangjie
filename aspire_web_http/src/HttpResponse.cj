package aspire_web_http

import std.io.InputStream

public abstract class HttpResponse {
    public func status(status: UInt16): Unit
    public func write(text: String): Unit
    public func write(bytes: Array<Byte>): Unit
    public func write(stream: InputStream): Unit
    public func addHeader(name: String, value: String): Unit
}
