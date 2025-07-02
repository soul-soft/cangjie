package aspire_extensions_healthchecks

import aspire_extensions_options.*
import aspire_extensions_injection.*


public interface HealthCheckExtension {
    func addHealthChecks(): HealthChecksBuilder
}

extend ServiceCollection <: HealthCheckExtension {
    public func addHealthChecks() {
        this.addOptions<HealthCheckServiceOptions>()
        this.tryAddSingleton<IHealthCheckService, HealthCheckService> {sp => HealthCheckService(sp, sp.getOrThrow<IOptions<HealthCheckServiceOptions>>())}
        return HealthChecksBuilder(this)
    }
}
