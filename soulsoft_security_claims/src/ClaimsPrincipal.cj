package soulsoft_security_claims

import std.collection.*

public class ClaimsPrincipal {
    private let _claimsIdenties: ArrayList<ClaimsIdentity>

    public init(claimsIdenties: Array<ClaimsIdentity>) {
        _claimsIdenties = ArrayList<ClaimsIdentity>(claimsIdenties)
    }

    public func addIdentity(claimsIdenty: ClaimsIdentity) {
        _claimsIdenties.add(claimsIdenty)
    }

    public func addIdentity(claimsIdenties: Collection<ClaimsIdentity>) {
        _claimsIdenties.add(all: claimsIdenties)
    }

    public prop identies: Collection<ClaimsIdentity> {
        get() {
            _claimsIdenties
        }
    }

    public prop claims: Collection<Claim> {
        get() {
            _claimsIdenties |> flatMap {f => f.claims} |> collectArray
        }
    }

    public func findAll(name: String) {
        claims |> filter {f => f.name == name}
    }

    public func findFirst(name: String) {
        _claimsIdenties |> flatMap {f => f.claims} |> filter {f => f.name == name} |> first
    }

    public func findFirstValue(name: String) {
        (_claimsIdenties |> flatMap {f => f.claims} |> filter {f => f.name == name} |> first).flatMap {f => f.value}
    }
}
