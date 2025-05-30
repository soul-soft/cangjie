package soulsoft_asp_authorization

import soulsoft_asp_http.*

@Annotation[target: [Type, MemberFunction]]
public class Authorize <: IAuthorizeData {
    private let _policy: ?String
    private let _authenticationSchemes: ?String

    public const init() {
        this(policy: None, authenticationSchemes: None)
    }

    public const init(policy: String) {
        this(policy: policy, authenticationSchemes: None)
    }

    public const init(policy!: ?String = None, authenticationSchemes!: ?String) {
        _policy = policy
        _authenticationSchemes = authenticationSchemes
    }

    public prop policy: ?String {
        get() {
            _policy
        }
    }

    public prop authenticationSchemes: ?String {
        get() {
            _authenticationSchemes
        }
    }
}
