package soulsoft_web_mvc.annotations

import soulsoft_web_http.*
import soulsoft_web_mvc.routing.*

@Annotation[target: [MemberFunction]]
public class HttpPut <: HttpMethod {
    public const init() {
        super(HttpMethods.put, String.empty)
    }

    public const init(template: String) {
        super(HttpMethods.put, template)
    }
}
