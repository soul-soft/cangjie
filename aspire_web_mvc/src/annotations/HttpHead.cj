package aspire_web_mvc.annotations

import aspire_web_http.*
import aspire_web_mvc.routing.*

@Annotation[target: [MemberFunction]]
public class HttpHead <: HttpMethod {
       public const init() {
        super(HttpMethods.head, String.empty)
    }

    public const init(template: String) {
        super(HttpMethods.head, template)
    }
}
