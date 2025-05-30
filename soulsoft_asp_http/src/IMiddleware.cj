package soulsoft_asp_http

public interface IMiddleware {
    func invoke(context: HttpContext, next: () -> Unit): Unit
}