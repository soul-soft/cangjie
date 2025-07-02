package aspire_web_authorization

public class DefaultAuthorizationEvaluator <: IAuthorizationEvaluator {
    public func evaluate(context: AuthorizationHandlerContext) {
        if (context.hasSucceeded) {
            return AuthorizationResult.success()
        } else {
            let failure = if (context.hasFailed) {
                AuthorizationFailure.failed(context.failedReasons)
            } else {
                AuthorizationFailure.failed(context.pendingRequirements)
            }
            return AuthorizationResult.failed(failure)
        }
    }
}
