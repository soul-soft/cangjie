package aspire_web_mvc.annotations

import aspire_web_http.*

@Annotation[target: [MemberFunction]]
public class HttpOptions <: HttpMethod {
    public const init() {
        super(HttpMethods.options, String.empty)
    }

    public const init(template: String) {
        super(HttpMethods.options, template)
    }
}
