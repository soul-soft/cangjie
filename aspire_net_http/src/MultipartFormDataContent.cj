package aspire_net_http

import std.io.*
import std.random.Random
import std.time.*

public class MultipartFormDataContent <: HttpContent {
    private let _boundary: String
    private let _body = ByteBuffer()

    public init() {
        this("--------------------------${DateTime.now().format("yyyyMMddHHmmss")}")
    }

    public init(boundary: String) {
        _boundary = boundary
        headers.add("content-type", "multipart/form-data; boundary=${_boundary}")
    }

    public func add(content: HttpContent) {
        add(content, String.empty, String.empty)
    }

    public func add(content: HttpContent, name: String) {
        add(content, name, String.empty)
    }

    public func add(content: HttpContent, name: String, fileName: String) {
        _body.write("--${_boundary}\r\n".toArray())
        if (let Some(contentType) <- content.headers.getFirst("Content-Type")) {
            _body.write("Content-Type: ${contentType}\r\n".toArray())
        }
        _body.write("Content-Disposition: form-data".toArray())
        if (name != String.empty) {
            _body.write("; name=${name}".toArray())
        }
        if (fileName != String.empty) {
            _body.write("; filename=${fileName}".toArray())
        }
        _body.write("\r\n\r\n".toArray())
        _body.write(content.readAsByteArray())
        _body.write("\r\n".toArray())
    }

    public func readAsStream(): InputStream {
        _body.write("--${_boundary}--\r\n".toArray())
        return _body
    }
}
