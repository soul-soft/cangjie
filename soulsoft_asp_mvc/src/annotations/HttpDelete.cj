package soulsoft_asp_mvc.annotations

import soulsoft_asp_http.*

@Annotation[target: [MemberFunction]]
public class HttpDelete <: HttpMethod {
    public const init() {
        super(HttpMethods.delete, String.empty)
    }

    public const init(template: String) {
        super(HttpMethods.delete, template)
    }
}
