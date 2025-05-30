package soulsoft_extensions_logging

public enum LogLevel <: Comparable<LogLevel> & ToString {
    Trace | Debug | Info | Warn | Error | Fatal | Off

    public operator func >(right: LogLevel): Bool {
        this.value() > right.value()
    }

    public operator func <(right: LogLevel): Bool {
        this.value() < right.value()
    }

    public operator func ==(right: LogLevel): Bool {
        this.value() == right.value()
    }

    public operator func !=(right: LogLevel): Bool {
        this.value() != right.value()
    }

    public func compare(right: LogLevel): Ordering {
        if(this == right) {
            Ordering.EQ
        }
        else if(this > right) {
            Ordering.GT
        }
        else {
             Ordering.LT
        }
    }

    public func toString(): String {
        return match (this) {
            case Trace => "trace"
            case Debug => "debug"
            case Info => "info"
            case Warn => "warn"
            case Error => "error"
            case Fatal => "fatal"
            case Off => "off"
        }
    }

    private func value() {
        return match (this) {
            case Trace => 0
            case Debug => 1
            case Info => 2
            case Warn => 3
            case Error => 4
            case Fatal => 5
            case Off => 6
        }
    }
}
