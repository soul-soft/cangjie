package soulsoft_asp_http

import std.convert.*

public struct HostString <: Equatable<HostString> & Equatable<String> & ToString{
    private let _value: String

    public init(value: String) {
        _value = value
    }

    public init(host: String, port: Int64) {
        _value = "${host}:${port}"
    }

    public prop host: String {
        get() {
            let (host, _) = getParts(_value)
            return host
        }
    }

    public prop port: Int64 {
        get() {
            let (_, port) = getParts(_value)
            return port
        }
    }

    private static func getParts(value: String): (String, Int64) {
        let parts = value.split(":")
        let host = parts[0]
        let port = if (parts.size > 1) {
            Int64.parse(parts[1])
        } else {
            80
        }
        return (host, port)
    }

    public prop value: String {
        get() {
            _value
        }
    }

    public prop hasValue: Bool {
        get() {
            _value.size > 0
        }
    }

    public operator func ==(oth: HostString) {
        return this.value == oth.value
    }

    public operator func ==(value: String) {
        return this.value == value
    }

    public func toString() {
        _value
    }
}
