package soulsoft_extensions_healthchecks

public interface IHealthCheck {
    func check(context: HealthCheckContext): HealthCheckResult
}
