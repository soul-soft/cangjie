package aspire_web_http

import aspire_identity_claims.*
import aspire_extensions_injection.*

public abstract class HttpContext {
    
    public prop request: HttpRequest
    
    public prop response: HttpResponse

    public mut prop user: ClaimsPrincipal

    public prop services: IServiceProvider

    public prop features: IFeatureCollection
}
