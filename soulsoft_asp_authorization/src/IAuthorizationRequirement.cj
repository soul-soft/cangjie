package soulsoft_asp_authorization

import std.reflect.*

public interface IAuthorizationRequirement <: Hashable & Equatable<IAuthorizationRequirement> & ToString {
    operator func ==(other: IAuthorizationRequirement) {
        refEq((this as Object).getOrThrow(), (other as Object).getOrThrow())
    }

    func hashCode() {
        ClassTypeInfo.of(this).hashCode()
    }
}
