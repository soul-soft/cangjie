package soulsoft_extensions_healthchecks

import std.collection.*

public class HealthReport {
    private let _status: HealthStatus
    private let _totalDuration: Duration
    private let _entries: ReadOnlyMap<String, HealthReportEntry>

    public init(status: HealthStatus, totalDuration: Duration, entries: ReadOnlyMap<String, HealthReportEntry>) {
        _status = status
        _totalDuration = totalDuration
        _entries = entries
    }

    public init(entries: ReadOnlyMap<String, HealthReportEntry>) {
        this(calculateAggregateStatus(entries.values()), calculateTotalDuration(entries.values()), entries)
    }

    public prop status: HealthStatus {
        get() {
            _status
        }
    }

    public prop totalDuration: Duration {
        get() {
            _totalDuration
        }
    }

    public prop entries: ReadOnlyMap<String, HealthReportEntry> {
        get() {
            _entries
        }
    }

    private static func calculateTotalDuration(entries: Iterable<HealthReportEntry>) {
        var totalSeconds = 0
        for (pattern in entries) {
            totalSeconds += pattern.duration.toMilliseconds()
        }
        Duration.millisecond * totalSeconds
    }
    private static func calculateAggregateStatus(entries: Iterable<HealthReportEntry>) {
        var currentValue = statusToNumber(HealthStatus.healthy)
        for (pattern in entries) {
            let value = statusToNumber(pattern.status)
            if (currentValue > value) {
                currentValue = value
                if (currentValue == statusToNumber(HealthStatus.unhealthy)) {
                    return HealthStatus.unhealthy
                }
            }
        }
        return statusToNumber(currentValue)
    }

    private static func statusToNumber(status: HealthStatus) {
        return match (status) {
            case HealthStatus.unhealthy => 0
            case HealthStatus.degraded => 1
            case HealthStatus.healthy => 2
        }
    }

    private static func statusToNumber(number: Int64) {
        if (number == 0) {
            HealthStatus.unhealthy
        } else if (number == 1) {
            HealthStatus.degraded
        }
        return HealthStatus.healthy
    }
}
