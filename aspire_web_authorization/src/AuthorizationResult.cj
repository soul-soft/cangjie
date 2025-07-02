package aspire_web_authorization

public class AuthorizationResult {
    private var _succeeded = false
    private var _failure: ?AuthorizationFailure = None

    private static let _successResult: AuthorizationResult
    private static let _failedResult: AuthorizationResult

    static init() {
        _successResult = AuthorizationResult()
        _successResult._succeeded = true
        _failedResult = AuthorizationResult()
        _failedResult._failure = AuthorizationFailure.explicitFail()
    }

    public prop succeeded: Bool {
        get() {
            _succeeded
        }
    }

    public prop failure: ?AuthorizationFailure {
        get() {
            _failure
        }
    }

    public static func success() {
        _successResult
    }

    public static func failed(failure: AuthorizationFailure) {
        let result = AuthorizationResult()
        result._failure = failure
        return result
    }

    public static func failed() {
        return _failedResult
    }
}
