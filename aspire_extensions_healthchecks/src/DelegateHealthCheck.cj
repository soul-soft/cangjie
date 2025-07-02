package aspire_extensions_healthchecks

public class DelegateHealthCheck <: IHealthCheck {
    private let _check: () -> HealthCheckResult

    init(check: () -> HealthCheckResult) {
        _check = check
    }

    public func check(_: HealthCheckContext): HealthCheckResult {
        return _check()
    }
}
