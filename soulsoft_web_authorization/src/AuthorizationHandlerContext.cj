package soulsoft_web_authorization

import std.collection.*
import soulsoft_security_claims.*

public class AuthorizationHandlerContext {
    private var _failCalled = false
    private var _succeedCalled = false
    private let _resource: ?Object
    private let _user: ClaimsPrincipal
    private let _requirements: Collection<IAuthorizationRequirement>
    private var _failedReasons = ArrayList<AuthorizationFailureReason>()
    private let _pendingRequirements: HashSet<IAuthorizationRequirement>

    init(requirements: Collection<IAuthorizationRequirement>, user: ClaimsPrincipal, resource: ?Object) {
        _requirements = requirements
        _user = user
        _resource = resource
        _pendingRequirements = HashSet<IAuthorizationRequirement>(requirements)
    }

    public prop requirements: Collection<IAuthorizationRequirement> {
        get() {
            _requirements
        }
    }

    public prop user: ClaimsPrincipal {
        get() {
            _user
        }
    }

    public prop resource: ?Object {
        get() {
            _resource
        }
    }

    //Gets the requirements that have not yet been marked as succeeded.
    public prop pendingRequirements: Collection<IAuthorizationRequirement> {
        get() {
            _pendingRequirements
        }
    }

    public prop failedReasons: Collection<AuthorizationFailureReason> {
        get() {
            _failedReasons
        }
    }

    public prop hasFailed: Bool {
        get() {
            _failCalled
        }
    }

    public prop hasSucceeded: Bool {
        get() {
            !_failCalled && _succeedCalled && pendingRequirements.size == 0
        }
    }

    public func fail() {
        _failCalled = true
    }

    public func fail(reason: AuthorizationFailureReason) {
        fail()
        _failedReasons.add(reason)
    }

    public func succeed(requirement: IAuthorizationRequirement) {
        _succeedCalled = true
        _pendingRequirements.remove(requirement)
    }
}
