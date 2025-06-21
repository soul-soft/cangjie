package soulsoft_net_http

import stdx.net.tls.*
import stdx.net.http.*
import stdx.encoding.url.*
import std.collection.*

public class HttpClient <: Resource {
    private let _client: Client
    private var _isColsed: Bool = false
    private let _options: HttpClientOptions
    private var _delegating: ?DelegatingHandler = None

    public init(configureOptions: (HttpClientOptions) -> Unit) {
        _options = HttpClientOptions()
        configureOptions(_options)
        _client = createClient(_options)
    }

    public init() {
        this({_ =>})
    }

    private static func createClient(options: HttpClientOptions) {
        let builder = ClientBuilder()
        builder.readTimeout(options.timeout)
        builder.writeTimeout(options.timeout)
        var tlsConfig = TlsClientConfig()
        tlsConfig.verifyMode = CertificateVerifyMode.TrustAll
        builder.tlsConfig(tlsConfig)
        return builder.build()
    }

    public func get(requestUri: String) {
        return get(URL.parse(requestUri))
    }

    public func get(requestUri: URL) {
        let request = HttpRequestMessage(HttpMethod.get, requestUri)
        return send(request)
    }

    public func getString(requestUri: String) {
        let response = get(requestUri)
        response.ensureSuccessStatusCode()
        return response.content.readAsString()
    }

    public func getString(requestUri: URL) {
        let response = get(requestUri)
        response.ensureSuccessStatusCode()
        return response.content.readAsString()
    }

    public func getByteArray(requestUri: String) {
        let response = get(requestUri)
        response.ensureSuccessStatusCode()
        return response.content.readAsByteArray()
    }

    public func getByteArray(requestUri: URL) {
        let response = get(requestUri)
        response.ensureSuccessStatusCode()
        return response.content.readAsByteArray()
    }

    public func getStream(requestUri: String) {
        let response = get(requestUri)
        response.ensureSuccessStatusCode()
        return response.content.readAsStream()
    }

    public func getStream(requestUri: URL) {
        let response = get(requestUri)
        response.ensureSuccessStatusCode()
        return response.content.readAsStream()
    }

    public func post(requestUri: String, content: ?HttpContent) {
        return post(URL.parse(requestUri), content)
    }

    public func post(requestUri: URL, content: ?HttpContent) {
        let request = HttpRequestMessage(HttpMethod.post, requestUri)
        request.content = content
        return send(request)
    }

    public func put(requestUri: String, content: ?HttpContent) {
        return put(URL.parse(requestUri), content)
    }

    public func put(requestUri: URL, content: ?HttpContent) {
        let request = HttpRequestMessage(HttpMethod.put, requestUri)
        request.content = content
        return send(request)
    }

    public func delete(requestUri: String, content: ?HttpContent) {
        return delete(URL.parse(requestUri), content)
    }

    public func delete(requestUri: URL, content: ?HttpContent) {
        let request = HttpRequestMessage(HttpMethod.delete, requestUri)
        request.content = content
        return send(request)
    }

    public func send(request: HttpRequestMessage): HttpResponseMessage {
        try {
            if (let Some(delegating) <- _delegating) {
                return delegating(request)
            } else {
                let delegate = build()
                _delegating = delegate
                return delegate(request)
            }
        } catch (ex: Exception) {
            throw HttpRequestException(ex.message, None)
        }
    }

    private func handle(request: HttpRequestMessage): HttpResponseMessage {
        let requestBuilder = HttpRequestBuilder()
        if (let Some(url) <- _options.address.flatMap {url => url.resolveURL(request.requestUri)}) {
            requestBuilder.url(url)
        } else {
            requestBuilder.url(request.requestUri)
        }
        requestBuilder.method(request.method.toString())
        for ((name, values) in request.headers) {
            for (value in values) {
                requestBuilder.header(name, value)
            }
        }
        if (let Some(content) <- request.content) {
            for ((name, values) in content.headers) {
                for (value in values) {
                    requestBuilder.header(name, value)
                }
            }
            requestBuilder.body(content.readAsStream())
        }
        for ((name, values) in _options.headers) {
            for (value in values) {
                requestBuilder.header(name, value)
            }
        }
        let response = _client.send(requestBuilder.build())
        return HttpResponseMessage(request, response)
    }

    private func build() {
        let middlewares = ArrayList<(DelegatingHandler) -> DelegatingHandler>()
        for (handler in _options.handlers) {
            middlewares.add({
                next => {
                    request => handler.send(request, next)
                }
            })
        }
        var app = handle
        var index = middlewares.size - 1;
        while (index >= 0) {
            let middleware = middlewares[index]
            app = middleware(app)
            index--
        }

        return app
    }

    public func isClosed() {
        return _isColsed
    }

    public func close() {
        if (isClosed()) {
            return
        }
        _client.close()
        _isColsed = true
    }
}
