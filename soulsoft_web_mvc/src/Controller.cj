package soulsoft_web_mvc

import soulsoft_web_http.*
import stdx.encoding.json.*
import stdx.serialization.serialization.*

public abstract class Controller {
    private var _context: ?HttpContext = None

    protected prop context: HttpContext {
        get() {
            _context.getOrThrow()
        }
    }

    protected prop request: HttpRequest {
        get() {
            context.request
        }
    }

    protected prop response: HttpResponse {
        get() {
            context.response
        }
    }

    protected func ok() {
        return ObjectResult(HttpStatusCode.Ok)
    }

    protected func ok(value: Object, contentType: ?String) {
        return ObjectResult(value, contentType)
    }

    protected func content(content: String) {
        return ContentResult(content)
    }

    protected func noContent() {
        return ObjectResult(HttpStatusCode.NoContent)
    }

    protected func status(status: UInt16) {
        return ObjectResult(status)
    }

    protected func notFound() {
        return ObjectResult(404)
    }

    protected func unauthorized() {
        return ObjectResult(401)
    }

    protected func badRequest() {
        return ObjectResult(400)
    }

    protected func redirect(url: String) {
        return RedirectResult(url)
    }

    protected func json(json: String) {
        return ContentResult(json, "application/json;charset=utf-8")
    }

    protected func json<T>(obj: Serializable<T>) {
        return json(obj.serialize().toJson().toJsonString())
    }

    protected func setup(context: HttpContext) {
        _context = context
        return this
    }

    public static func build(): Array<Endpoint> {
        throw UnsupportedException("The @ApiController attribute is missing from the controller class.")
    }
}
