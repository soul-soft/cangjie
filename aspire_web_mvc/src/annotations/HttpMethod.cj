package aspire_web_mvc.annotations

import aspire_web_mvc.abstractions.*

public abstract class HttpMethod <: IActionHttpMethodProvider & IRouteTemplateProvider {
    private let _template: ?String
    private let _httpMethods: String

    public const init(httpMethods: String) {
        this._template = None
        this._httpMethods = httpMethods
    }

    public const init(httpMethods: String, template: String) {
        this._template = template
        this._httpMethods = httpMethods
    }

    public prop template: ?String {
        get() {
            _template
        }
    }

    public prop httpMethods: Array<String> {
        get() {
            [_httpMethods]
        }
    }
}
