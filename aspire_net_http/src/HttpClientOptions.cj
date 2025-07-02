package aspire_net_http

import stdx.net.http.*
import stdx.encoding.url.*
import std.collection.*

public class HttpClientOptions {
    private var _address: ?URL = None
    private let _headers = HttpHeaders()
    private var _timeout: Duration = Duration.second * 180
    private let _handlers = ArrayList<IHttpMessageHandler>()

    public prop handlers: ArrayList<IHttpMessageHandler> {
        get() {
            return _handlers
        }
    }

    public prop headers: HttpHeaders {
        get() {
            return _headers
        }
    }

    public mut prop address: ?URL {
        get() {
            return _address
        }
        set(value) {
            if (let Some(url) <- value) {
                if (!url.isAbsoluteURL()) {
                    throw IllegalArgumentException("The provided URL must be absolute.")
                }
            }
            _address = value
        }
    }

    public mut prop timeout: Duration {
        get() {
            return _timeout
        }
        set(value) {
            if (value < Duration.Zero) {
                throw IllegalArgumentException("Timeout must be greater than zero.")
            }
            _timeout = value
        }
    }
}
