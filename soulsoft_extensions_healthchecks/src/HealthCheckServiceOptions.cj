package soulsoft_extensions_healthchecks

import std.collection.*

public class HealthCheckServiceOptions {
    private let _registrations: List<HealthCheckRegistration>

    public init() {
        _registrations = ArrayList<HealthCheckRegistration>()
    }

    public prop registrations: List<HealthCheckRegistration> {
        get() {
            _registrations
        }
    }
}
