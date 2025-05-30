package soulsoft_extensions_healthchecks

import std.time.*
import std.collection.*
import soulsoft_extensions_options.*
import soulsoft_extensions_injection.*

public interface IHealthCheckService {
    func check(): HealthReport
}

class HealthCheckService <: IHealthCheckService {
    HealthCheckService(let services: IServiceProvider, let options: IOptions<HealthCheckServiceOptions>) {
    }
    public func check(): HealthReport {
        let registrations = options.value.registrations

        var tasks = ArrayList<Future<(HealthReportEntry)>>()
        for (pattern in registrations) {
            let task = runCheck(pattern)
            tasks.add((task))
        }

        var index = 0
        let entries = HashMap<String, HealthReportEntry>()
        for (pattern in registrations) {
            entries[pattern.name] = tasks[index].get(pattern.timeout)
        }
        return HealthReport(entries)
    }

    private func runCheck(registration: HealthCheckRegistration) {
        return spawn {
            let scope = services.createScope()
            let start = DateTime.now()
            try {
                let instance = registration.factory(scope.services)
                let result = instance.check(HealthCheckContext(registration))
                let duration = DateTime.now() - start
                return HealthReportEntry(result.status, duration, result.description, result.exception, registration.tags, result.data)
            } catch (ex: Exception) {
                    let duration = DateTime.now() - start
                    return HealthReportEntry(HealthStatus.unhealthy, duration, ex.message, ex, registration.tags)
            } finally {
                scope.close()
            }
        }
    }
}
