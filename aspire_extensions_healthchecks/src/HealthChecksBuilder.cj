package aspire_extensions_healthchecks

import aspire_extensions_options.*
import aspire_extensions_injection.*

public class HealthChecksBuilder {
    private let _services: ServiceCollection

    init(services: ServiceCollection) {
        _services = services
    }

    public func addCheck(registration: HealthCheckRegistration) {
        _services.configure<HealthCheckServiceOptions> {
            options => options.registrations.add(registration)
        }
        return this
    }

    public func addCheck(name: String, check: () -> HealthCheckResult) {
        addCheck(name, Duration.Zero, Array<String>(), check)
        return this
    }

    public func addCheck(name: String, tags: Array<String>, check: () -> HealthCheckResult) {
        addCheck(name, Duration.Zero, tags, check)
        return this
    }

    public func addCheck(name: String, timeout: Duration, tags: Array<String>, check: () -> HealthCheckResult) {
        addCheck(HealthCheckRegistration(name, timeout, tags, {
            _ => DelegateHealthCheck(check)
        }))
        return this
    }

    public func addCheck<T>(name: String) where T <: IHealthCheck {
        addCheck(HealthCheckRegistration(name, Duration.Zero, Array<String>(), {
            sp => ActivatorUtilities.createInstance<T>(sp)
        }))
        return this
    }

    public func addCheck<T>(name: String, tags: Array<String>) where T <: IHealthCheck {
        addCheck(HealthCheckRegistration(name, Duration.Zero, tags, {
            sp => ActivatorUtilities.createInstance<T>(sp)
        }))
        return this
    }

    public func addCheck<T>(name: String, timeout: Duration, tags: Array<String>) where T <: IHealthCheck {
        addCheck(HealthCheckRegistration(name, timeout, tags, {
            sp => ActivatorUtilities.createInstance<T>(sp)
        }))
        return this
    }
}
