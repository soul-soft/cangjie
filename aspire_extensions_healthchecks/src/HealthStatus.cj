package aspire_extensions_healthchecks

public enum HealthStatus <: ToString {
    unhealthy | degraded | healthy

    public func toString() {
        match (this) {
            case unhealthy => "unhealthy"
            case degraded => "degraded"
            case healthy => "healthy"
        }
    }
}
