package aspire_web_mvc.annotations

import aspire_web_http.*

@Annotation[target: [MemberFunction]]
public class HttpGet <: HttpMethod {
    public const init() {
        super(HttpMethods.get, String.empty)
    }

    public const init(template: String) {
        super(HttpMethods.get, template)
    }
}
