package soulsoft_extensions_hosting

public abstract class BackgroundService <: IHostedService & Resource {
    private var _future: ?Future<Unit> = None

    public func start(): Unit {
        _future = spawn {
            run()
        }
    }

    public func stop(): Unit {
        _future?.cancel()
    }

    public func run(): Unit

    public open func isClosed() {
        
        return true
    }

    public open func close() {
        
    }
}
