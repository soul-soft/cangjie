package aspire_extensions_hosting

import std.collection.*

public interface IHostLifetime {
    func onStarted(callback: () -> Unit): Unit
    func onStopped(callback: () -> Unit): Unit
    func onStopping(callback: () -> Unit): Unit
}

public class HostLifetime <: IHostLifetime {
    private let _startedEvents = ArrayList<() -> Unit>()
    private let _stoppedEvents = ArrayList<() -> Unit>()
    private let _stoppingEvents = ArrayList<() -> Unit>()

    public func onStarted(callback: () -> Unit) {
        _startedEvents.add(callback)
    }

    public func onStopped(callback: () -> Unit) {
        _stoppedEvents.add(callback)
    }

    public func onStopping(callback: () -> Unit) {
        _stoppingEvents.add(callback)
    }

    public func started() {
        for (pattern in _startedEvents) {
            try {
                pattern()
            } catch (_: Exception) {
            }
        }
    }

    public func stopped() {
        for (pattern in _stoppedEvents) {
            try {
                pattern()
            } catch (_: Exception) {
            }
        }
    }

    public func stopping() {
        for (pattern in _stoppingEvents) {
            try {
                pattern()
            } catch (_: Exception) {
            }
        }
    }
}
