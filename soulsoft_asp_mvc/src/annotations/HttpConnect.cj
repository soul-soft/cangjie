package soulsoft_asp_mvc.annotations

import soulsoft_asp_http.*

@Annotation[target: [MemberFunction]]
public class HttpConnect <: HttpMethod {
    public const init() {
        super(HttpMethods.connect, String.empty)
    }

    public const init(template: String) {
        super(HttpMethods.connect, template)
    }
}
