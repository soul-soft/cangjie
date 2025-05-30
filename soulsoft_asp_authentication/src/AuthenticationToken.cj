package soulsoft_asp_authentication

public class AuthenticationToken {
    private let _name: String
    private let _value: String
    
    public init(name: String, value: String) {
        _name = name
        _value = value
    }
}
