package soulsoft_extensions_healthchecks

import std.collection.*

public class HealthCheckResult {
    private let _status: HealthStatus
    private let _description: ?String
    private let _exception: ?Exception
    private let _data: ReadOnlyMap<String, Object>

    init(status: HealthStatus, description: ?String, exception: ?Exception, data: HashMap<String, Object>) {
        _data = data
        _status = status
        _exception = exception
        _description = description
    }

    public prop status: HealthStatus {
        get() {
            _status
        }
    }

    public prop data: ReadOnlyMap<String, Object> {
        get() {
            _data
        }
    }

    public prop exception: ?Exception {
        get() {
            _exception
        }
    }

    public prop description: ?String {
        get() {
            _description
        }
    }

    public static func healthy(description!: ?String = None) {
        HealthCheckResult(HealthStatus.healthy, description, None, HashMap<String, Object>())
    }

    public static func healthy(description!: ?String = None, data!: HashMap<String, Object>) {
        HealthCheckResult(HealthStatus.healthy, description, None, data)
    }

    public static func degraded(description!: ?String = None, exception!: ?Exception = None,
        data!: HashMap<String, Object>) {
        HealthCheckResult(HealthStatus.degraded, description, exception, data)
    }

    public static func degraded(description!: ?String = None, exception!: ?Exception = None) {
        HealthCheckResult(HealthStatus.degraded, description, exception, HashMap<String, Object>())
    }

    public static func unhealthy(description!: ?String = None, exception!: ?Exception = None,
        data!: HashMap<String, Object>) {
        HealthCheckResult(HealthStatus.unhealthy, description, exception, data)
    }

    public static func unhealthy(description!: ?String = None, exception!: ?Exception = None) {
        HealthCheckResult(HealthStatus.unhealthy, description, exception, HashMap<String, Object>())
    }
}
