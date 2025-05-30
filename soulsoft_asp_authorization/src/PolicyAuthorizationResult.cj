package soulsoft_asp_authorization

public class PolicyAuthorizationResult {
    private var _challenged = false
    private var _forbidden = false
    private var _succeeded = false

    private static let _challengedResult = static_init {
        x => x._challenged = true
    }

    private static let _forbiddenResult = static_init {
        x => x._forbidden = true
    }

    private static let _succeededResult = static_init {
        x => x._succeeded = true
    }

    private var _authorizationFailure: ?AuthorizationFailure = None

    public prop challenged: Bool {
        get() {
            _challenged
        }
    }

    public prop forbidden: Bool {
        get() {
            _forbidden
        }
    }

    public prop succeeded : Bool {
        get() {
            _succeeded
        }
    }

    public static func forbid() {
        _forbiddenResult
    }

    public static func challenge() {
        _challengedResult
    }

    public static func success() {
        _succeededResult
    }

    public static func forbid(authorizationFailure: ?AuthorizationFailure) {
        if (let Some(authorizationFailure) <- authorizationFailure) {
            let result = PolicyAuthorizationResult()
            result._forbidden = true
            result._authorizationFailure = authorizationFailure
            return result
        }else {
            return forbid()
        }
    }

    private static func static_init(configure: (PolicyAuthorizationResult) -> Unit) {
        let entry = PolicyAuthorizationResult()
        configure(entry)
        return entry
    }
}
