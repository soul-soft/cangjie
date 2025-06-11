package soulsoft_asp_http

public struct QueryString <: Equatable<QueryString> & Equatable<String> & ToString{
    private let _value: String

    public init(value: String) {
        _value = value
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

    public operator func ==(oth: QueryString) {
        return this.value == oth.value
    }

    public operator func ==(value: String) {
        return this.value == value
    }

    public func toString() {
        _value
    }
}
