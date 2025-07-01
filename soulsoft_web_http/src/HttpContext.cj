package soulsoft_web_http

import soulsoft_security_claims.*
import soulsoft_extensions_injection.*

public abstract class HttpContext {
    
    public prop request: HttpRequest
    
    public prop response: HttpResponse

    public mut prop user: ClaimsPrincipal

    public prop services: IServiceProvider

    public prop features: IFeatureCollection
}
