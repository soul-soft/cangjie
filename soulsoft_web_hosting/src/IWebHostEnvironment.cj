package soulsoft_web_hosting

public interface IWebHostEnvironment <: IHostEnvironment {
    prop webRootPath: String
}

class WebHostEnvironment <: IWebHostEnvironment {
    private let _webRootPath: String
    private let _hostEnvironment: IHostEnvironment

    public init(webRootPath: String, hostEnvironment: IHostEnvironment) {
        _webRootPath = webRootPath
        _hostEnvironment = hostEnvironment
    }

    public prop webRootPath: String {
        get() {
            _webRootPath
        }
    }

    public prop environmentName: String {
        get() {
            _hostEnvironment.environmentName
        }
    }

    public prop contentRootPath: String {
        get() {
            _hostEnvironment.contentRootPath
        }
    }

    public prop applicationName: String {
        get() {
            _hostEnvironment.applicationName
        }
    }
}
