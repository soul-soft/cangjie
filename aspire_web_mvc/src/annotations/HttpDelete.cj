package aspire_web_mvc.annotations

import aspire_web_http.*

@Annotation[target: [MemberFunction]]
public class HttpDelete <: HttpMethod {
    public const init() {
        super(HttpMethods.delete, String.empty)
    }

    public const init(template: String) {
        super(HttpMethods.delete, template)
    }
}
