package aspire_net_http

import std.io.ByteBuffer
import stdx.net.http.HttpResponse

public class HttpResponseMessage {
    private let _content: HttpContent
    private let _response: HttpResponse
    private let _request: HttpRequestMessage
    private let _headers: HttpResponseHeaders

    init(request: HttpRequestMessage, response: HttpResponse) {
        _request = request
        _response = response
        _content = StreamContent(response.body)
        _headers = HttpResponseHeaders(response.headers)
    }

    public prop status: UInt16 {
        get() {
            _response.status
        }
    }

    public prop headers: HttpResponseHeaders {
        get() {
            _headers
        }
    }

    public prop content: HttpContent {
        get() {
            _content
        }
    }

    public prop request: HttpRequestMessage {
        get() {
            _request
        }
    }

    public prop isSuccessStatusCode:Bool {
        get() {
            status >= 200 && status <= 299
        }
    }

    public func ensureSuccessStatusCode() {
        if (!isSuccessStatusCode) {
            let errorMessage = "Request failed with status code: ${status}"
            throw HttpRequestException(errorMessage, None)
        }
    }
}
