package soulsoft_asp_hosting

import soulsoft_asp_http.*
import stdx.net.http.HttpContext as HttpContextBase

class HttpContextImpl <: HttpContext {
    private let _request: HttpRequest
    private let _response: HttpResponseImpl
    private let _services: IServiceProvider

    init(context: HttpContextBase,services: IServiceProvider) {
        _request = HttpRequestImpl(context.request)
        _response = HttpResponseImpl(context.responseBuilder)
        _services = services
    }

    public prop request: HttpRequest {
        get() {
            _request
        }
    }

    public prop response: HttpResponse {
        get() {
            _response
        }
    }

    public prop services: IServiceProvider {
        get() {
            _services
        }
    }
}
