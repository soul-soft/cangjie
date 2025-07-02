package aspire_web_mvc.annotations

import aspire_web_http.*
import aspire_web_mvc.routing.*

@Annotation[target: [MemberFunction]]
public class HttpPut <: HttpMethod {
    public const init() {
        super(HttpMethods.put, String.empty)
    }

    public const init(template: String) {
        super(HttpMethods.put, template)
    }
}
