package soulsoft_asp_authentication

import soulsoft_asp_http.*

@Annotation[target: [Type, MemberFunction]]
public class Authorize <: IAuthorizeData {
    private let _roles: ?String
    private let _policy: ?String
    private let _authenticationSchemes: ?String

    public const init(policy: String) {
        this(policy: policy)
    }

    public const init(roles!: ?String = None, policy!: ?String = None, authenticationSchemes!: ?String = None) {
        _roles = roles
        _policy = policy
        _authenticationSchemes = authenticationSchemes
    }

    public prop roles: ?String {
        get() {
            _roles
        }
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
