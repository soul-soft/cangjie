package soulsoft_asp_mvc

import soulsoft_asp_http.*

public class RedirectResult <: IActionResult {
    private let _url: String

    init(url: String) {
        _url = url
    }

    public func invoke(context: HttpContext): Unit {
        context.response.status(HttpStatusCode.STATUS_FOUND)
        context.response.addHeader("location", _url)
    }
}
