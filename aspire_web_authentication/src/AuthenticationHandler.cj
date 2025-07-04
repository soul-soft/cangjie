package aspire_web_authentication

import std.reflect.*
import aspire_web_http.*
import aspire_extensions_options.*
import aspire_extensions_logging.*
import aspire_extensions_injection.*

public abstract class AuthenticationHandler<TOptions> <: IAuthenticationHandler where TOptions <: AuthenticationSchemeOptions {
    private var _options: ?TOptions = None
    private var _context: ?HttpContext = None
    private var _result: ?AuthenticateResult = None
    private var _scheme: ?AuthenticationScheme = None
    private let _logger: ILogger
    private let _optionsMonitor: IOptionsMonitor<TOptions>

    protected init(optionsMonitor: IOptionsMonitor<TOptions>, logFactory: ILoggerFactory) {
        _optionsMonitor = optionsMonitor
        _logger = logFactory.createLogger<AuthenticationHandler<TOptions>>()
    }

    public func initialize(scheme: AuthenticationScheme, context: HttpContext): Unit {
        _scheme = scheme
        _context = context
        _options = _optionsMonitor.get(scheme.name)
    }

    public func authenticate() {
        let result = handleAuthenticateOnce()
        return result
    }

    protected func handleAuthenticateOnce() {
        if (let Some(result) <- _result) {
            return result
        }
        let result = handleAuthenticate()
        _result = result
        return result
    }

    protected func handleAuthenticateOnceSafe() {
        try {
            return handleAuthenticateOnce()
        }catch (ex: Exception) {
            return AuthenticateResult.fail(ex)
        }
    }

    protected func handleAuthenticate(): AuthenticateResult

    protected open func handleForbidden(_: ?AuthenticationProperties): Unit {
        context.response.status(403)
    }

    protected open func handleChallenge(_: ?AuthenticationProperties): Unit {
        context.response.status(401)
    }

    public func challenge(properties: ?AuthenticationProperties): Unit {
        handleChallenge(properties)
    }

    public func forbid(properties: ?AuthenticationProperties): Unit {
        handleForbidden(properties)
    }

    public prop scheme: AuthenticationScheme {
        get() {
            return _scheme.getOrThrow()
        }
    }

    public prop context: HttpContext {
        get() {
            return _context.getOrThrow()
        }
    }

    public prop logger: ILogger {
        get() {
            _logger
        }
    }

    public prop options: TOptions {
        get() {
            _options.getOrThrow()
        }
    }
}
