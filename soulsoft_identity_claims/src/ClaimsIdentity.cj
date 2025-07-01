package soulsoft_identity_claims

import std.collection.*

public class ClaimsIdentity {
    private let _claims: ArrayList<Claim>
    private var _authenticationType: ?String = None

    public init(claims: Array<Claim>) {
        _claims = ArrayList<Claim>(claims)
    }

    public init(authenticationType: String, claims: Array<Claim>) {
        _claims = ArrayList<Claim>(claims)
        _authenticationType = authenticationType
    }

    public prop claims: Collection<Claim> {
        get() {
            _claims
        }
    }

    public prop isAuthenticated: Bool {
        get() {
            authenticationType.isSome()
        }
    }

    public prop authenticationType: ?String {
        get() {
            _authenticationType
        }
    }

    public func addClaim(Claim: Claim) {
        _claims.add(Claim)
    }

    public func addClaim(name: String, value: String) {
        _claims.add(Claim(name, value))
    }

    public func addClaim(name: String, value: String, valueType: ?String) {
        _claims.add(Claim(name, value, valueType))
    }

    public func addClaims(claims: Collection<Claim>) {
        _claims.add(all: claims)
    }
}
