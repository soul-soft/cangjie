package aspire_web_http

public interface IMiddleware {
    func invoke(context: HttpContext, next: () -> Unit): Unit
}