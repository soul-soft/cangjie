package soulsoft_net_http

import std.collection.*
import stdx.encoding.url.*

public class HttpRequestMessage {
    private let _requestUri: URL
    private let _method: HttpMethod
    private let _headers = HttpRequestHeaders()
    private let _properties = HashMap<String, Any>()

    public init(method: HttpMethod, requestUri: String) {
        this(method, URL.parse(requestUri))
    }

    public init(method: HttpMethod, requestUri: URL) {
        _method = method
        _requestUri = requestUri
    }

    public var content: ?HttpContent = None

    public prop method: HttpMethod {
        get() {
            _method
        }
    }

    public prop requestUri: URL {
        get() {
            _requestUri
        }
    }

    public prop headers: HttpRequestHeaders {
        get() {
            _headers
        }
    }

    public prop properties: HashMap<String, Any> {
        get() {
            _properties
        }
    }
}
