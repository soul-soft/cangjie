package soulsoft_web_mvc.annotations

import soulsoft_web_http.*
import soulsoft_web_mvc.routing.*

@Annotation[target: [MemberFunction]]
public class HttpPatch <: HttpMethod {
    public const init() {
        super(HttpMethods.patch, String.empty)
    }

    public const init(template: String) {
        super(HttpMethods.patch, template)
    }
}
