package soulsoft_asp_mvc.annotations

import soulsoft_asp_http.*
import soulsoft_asp_mvc.routing.*

@Annotation[target: [MemberFunction]]
public class HttpHead <: HttpMethod {
       public const init() {
        super(HttpMethods.head, String.empty)
    }

    public const init(template: String) {
        super(HttpMethods.head, template)
    }
}
