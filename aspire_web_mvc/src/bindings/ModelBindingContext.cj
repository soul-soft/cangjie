package aspire_web_mvc.bindings

import std.reflect.*
import aspire_web_http.*
import stdx.serialization.serialization.*

public class ModelBindingContext {
    private let _httpContext: HttpContext
    private let _parameters: Collection<ParameterInfo>

    public init(httpContext: HttpContext, parameters: Collection<ParameterInfo>) {
        _httpContext = httpContext
        _parameters = parameters
    }

    public prop httpContext: HttpContext {
        get() {
            _httpContext
        }
    }

    public prop parameters: Collection<ParameterInfo> {
        get() {
            _parameters
        }
    }
}
