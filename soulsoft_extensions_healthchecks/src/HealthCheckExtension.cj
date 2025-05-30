package soulsoft_extensions_healthchecks

import soulsoft_extensions_options.*
import soulsoft_extensions_injection.*


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
