package soulsoft_asp_mvc.annotations

import soulsoft_asp_http.*

@Annotation[target: [MemberFunction]]
public class HttpGet <: HttpMethod {
    public const init() {
        super(HttpMethods.get, String.empty)
    }

    public const init(template: String) {
        super(HttpMethods.get, template)
    }
}
