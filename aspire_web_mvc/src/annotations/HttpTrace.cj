package aspire_web_mvc.annotations

import aspire_web_http.*
import aspire_web_mvc.routing.*

@Annotation[target: [MemberFunction]]
public class HttpTrace <: HttpMethod {
    public const init() {
        super(HttpMethods.trace, String.empty)
    }

    public const init(template: String) {
        super(HttpMethods.trace, template)
    }
}
