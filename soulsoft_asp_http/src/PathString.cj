package soulsoft_asp_http

public struct PathString {
    private let _value: String
    
    public init(value: String) {
        _value = value
    }

    public prop value: String {
        get() {
            _value
        }
    }
}