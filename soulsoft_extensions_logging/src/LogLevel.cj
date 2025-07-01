package soulsoft_extensions_logging

public enum LogLevel <: Comparable<LogLevel> & ToString {
    Trace | Debug | Info | Warn | Error | Fatal | Off

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
}
