package soulsoft_web_authorization

public interface IAuthorizationEvaluator {
    func evaluate(context: AuthorizationHandlerContext): AuthorizationResult
}