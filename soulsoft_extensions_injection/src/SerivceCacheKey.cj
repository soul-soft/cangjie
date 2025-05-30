package soulsoft_extensions_injection

import std.reflect.*

struct SerivceCacheKey <: Hashable & Equatable<SerivceCacheKey> {
    private let _slot: Int64
    private let _identifier: ServiceIdentifier

    init(identifier: ServiceIdentifier, slot: Int64) {
        _identifier = identifier
        _slot = slot
    }

    public operator func ==(rhs: SerivceCacheKey): Bool {
        if (_identifier != rhs._identifier) {
            return false
        }
        if (_slot != rhs._slot) {
            return false
        }
        return true
    }

    @OverflowWrapping
    public func hashCode() {
        (_identifier.hashCode() * 397) ^ _slot
    }
}
