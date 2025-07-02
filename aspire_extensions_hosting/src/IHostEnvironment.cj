package aspire_extensions_hosting

public interface IHostEnvironment {
    prop environmentName: String
    prop contentRootPath: String
    prop applicationName: String
}

public class HostEnvironment <: IHostEnvironment {
    private let _environmentName: String
    private let _contentRootPath: String
    private let _applicationName: String
    
    public init(environmentName: String, contentRootPath: String, applicationName: String) {
        _environmentName = environmentName
        _contentRootPath = contentRootPath
        _applicationName = applicationName
    }
    
    public prop environmentName: String {
        get() {
            _environmentName
        }
    }

    public prop contentRootPath: String {
        get() {
            _contentRootPath
        }
    }

    public prop applicationName: String {
        get() {
            _applicationName
        }
    }
}
