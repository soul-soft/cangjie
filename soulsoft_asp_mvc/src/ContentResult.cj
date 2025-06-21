package soulsoft_asp_mvc

import soulsoft_asp_http.*

public class ContentResult <: IActionResult {
    private let _content: String
    private let _contentType: ?String

    init(content: String) {
        _content = content
        _contentType = None
    }

    init(content: String, contentType: String) {
        _content = content
        _contentType = contentType
    }

    public func invoke(context: HttpContext): Unit {
        if (_content.size == 0) {
            context.response.status(HttpStatusCode.NoContent)
        }else {
            context.response.status(HttpStatusCode.Ok)
            context.response.write(_content)
        }
        if (let Some(contentType) <- _contentType) {
            context.response.addHeader("content-type", contentType)
        }
    }
}
