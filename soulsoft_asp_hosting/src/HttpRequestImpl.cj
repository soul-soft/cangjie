package soulsoft_asp_hosting

import std.io.*
import std.collection.*
import stdx.encoding.url.{URL, Form}
import stdx.net.http.{HttpHeaders, Protocol}
import stdx.net.http.HttpRequest as HttpRequestBase

public class HttpRequestImpl <: HttpRequest {
    private let _request: HttpRequestBase
    private var _routeValues = RouteValues()

    init(request: HttpRequestBase) {
        _request = request
    }

    public prop body: InputStream {
        get() {
            _request.body
        }
    }

    public prop bodySize: ?Int64 {
        get() {
            _request.bodySize
        }
    }

    public prop close: Bool {
        get() {
            _request.close
        }
    }

    public prop form: Form {
        get() {
            _request.form
        }
    }

    public prop headers: HttpHeaders {
        get() {
            _request.headers
        }
    }

    public prop method: String {
        get() {
            _request.method
        }
    }

    public prop readTimeout: ?Duration {
        get() {
            _request.readTimeout
        }
    }

    public prop remoteAddr: String {
        get() {
            _request.remoteAddr
        }
    }

    public prop trailers: HttpHeaders {
        get() {
            _request.trailers
        }
    }

    public prop url: URL {
        get() {
            _request.url
        }
    }

    public prop version: Protocol {
        get() {
            _request.version
        }
    }

    public mut prop routeValues: RouteValues {
        get() {
            _routeValues
        }
        set(value) {
            _routeValues = value
        }
    }

    public prop writeTimeout: ?Duration {
        get() {
            _request.writeTimeout
        }
    }
}
