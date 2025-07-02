package aspire_web_hosting

import std.io.{InputStream, ByteBuffer}
import stdx.net.http.HttpResponseBuilder as HttpResponseBase

class HttpResponseImpl <: HttpResponse {
    private let _response: HttpResponseBase

    init(response: HttpResponseBase) {
        _response = response
    }

    public func status(status: UInt16): Unit {
        _response.status(status)
    }

    public func write(text: String): Unit {
        _response.body(text)
    }

    public func write(stream: InputStream): Unit {
        _response.body(stream)
    }

    public func write(bytes: Array<Byte>): Unit {
        _response.body(bytes)
    }

    public func addHeader(name: String, value: String): Unit {
        _response.header(name, value)
    }
}
