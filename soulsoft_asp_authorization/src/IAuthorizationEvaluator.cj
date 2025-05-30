package soulsoft_asp_authorization

public interface IAuthorizationEvaluator {
    func evaluate(context: AuthorizationHandlerContext): AuthorizationResult
}