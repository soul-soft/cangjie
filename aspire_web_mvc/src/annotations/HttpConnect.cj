package aspire_web_mvc.annotations

import aspire_web_http.*

@Annotation[target: [MemberFunction]]
public class HttpConnect <: HttpMethod {
    public const init() {
        super(HttpMethods.connect, String.empty)
    }

    public const init(template: String) {
        super(HttpMethods.connect, template)
    }
}
