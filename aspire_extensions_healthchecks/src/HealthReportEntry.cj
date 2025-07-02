package aspire_extensions_healthchecks

import std.collection.*

public struct HealthReportEntry {
    private let _status: HealthStatus
    private let _duration: Duration
    private let _exception: ?Exception
    private let _description: ?String
    private let _tags: Array<String>
    private let _data: ReadOnlyMap<String, Object>

    public init(status: HealthStatus, duration: Duration, description: ?String, exception: ?Exception, tags: Array<String>) {
        _status = status
        _duration = duration
        _description = description
        _exception = exception
        _tags = tags
        _data = HashMap<String, Object>()
    }

    public init(status: HealthStatus, duration: Duration, description: ?String, exception: ?Exception, tags: Array<String>,
        data: ReadOnlyMap<String, Object>) {
        _status = status
        _duration = duration
        _description = description
        _exception = exception
        _tags = tags
        _data = data
    }

    public prop status: HealthStatus {
        get() {
            _status
        }
    }

    public prop duration: Duration {
        get() {
            _duration
        }
    }

    public prop tags: Array<String> {
        get() {
            _tags
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
}
