package soulsoft_asp_hosting

import soulsoft_asp_http.*
import soulsoft_security_claims.*
import stdx.net.http.HttpContext as HttpContextBase

class HttpContextImpl <: HttpContext {
    private let _request: HttpRequest
    private var _user: ClaimsPrincipal
    private let _response: HttpResponseImpl
    private let _services: IServiceProvider
    private let _features: IFeatureCollection

    init(context: HttpContextBase,services: IServiceProvider) {
        _user = ClaimsPrincipal()
        _request = HttpRequestImpl(context.request)
        _response = HttpResponseImpl(context.responseBuilder)
        _features = FeatureCollection()
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

    public mut prop user: ClaimsPrincipal {
        get() {
            _user
        }
        set(value) {
            _user = value
        }
    }

    public prop services: IServiceProvider {
        get() {
            _services
        }
    }

    public prop features: IFeatureCollection {
        get() {
            _features
        }
    }
}
