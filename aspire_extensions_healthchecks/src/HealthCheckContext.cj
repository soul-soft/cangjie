package aspire_extensions_healthchecks

public class HealthCheckContext {
    private let _registration: HealthCheckRegistration

    init(registration: HealthCheckRegistration) {
        _registration = registration
    }

    public prop registration: HealthCheckRegistration {
        get() {
            _registration
        }
    }
}
