package aspire_web_mvc

import aspire_web_http.*

public class RedirectResult <: IActionResult {
    private let _url: String

    init(url: String) {
        _url = url
    }

    public func invoke(context: HttpContext): Unit {
        context.response.status(HttpStatusCode.Found)
        context.response.addHeader("location", _url)
    }
}
