package aspire_web_hosting

class HttpContextAccessor <: IHttpContextAccessor {
    private var _context: ?HttpContext = None

    public prop context: ?HttpContext {
        get() {
            _context
        }
    }

    public func setup(context: HttpContext) {
        _context = context
    }
}
