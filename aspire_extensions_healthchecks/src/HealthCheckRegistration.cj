package aspire_extensions_healthchecks

import aspire_extensions_injection.*

public class HealthCheckRegistration {
    private let _name: String
    private let _timeout: Duration
    private let _factory: (IServiceProvider) -> IHealthCheck
    private let _tags: Array<String>

    init(name: String, timeout: Duration, tags: Array<String>, factory: (IServiceProvider) -> IHealthCheck) {
        _name = name
        _tags = tags
        _timeout = timeout
        _factory = factory
    }
   
    public prop name: String {
        get() {
            _name
        }
    }

    public prop timeout: Duration {
        get() {
            _timeout
        }
    }
    
    public prop tags: Array<String> {
        get() {
            _tags
        }
    }

    public prop factory: (IServiceProvider) -> IHealthCheck {
        get() {
            _factory
        }
    }
}
