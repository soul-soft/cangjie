package aspire_web_mvc

import aspire_web_http.*

public class ObjectResult <: IActionResult {
    private let _value: ?Any
    private let _contentType: ?String
    private let _status: UInt16

    init(value: ?Any, contentType: ?String) {
        this(HttpStatusCode.Ok, value, contentType)
    }

    init(status: UInt16) {
        this(status, None, None)
    }

    init(status: UInt16, value: ?Any, contentType: ?String) {
        _status = status
        _value = value
        _contentType = contentType
    }

    public func invoke(_: HttpContext): Unit {
        
    }
}
