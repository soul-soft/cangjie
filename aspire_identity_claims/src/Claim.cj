package aspire_identity_claims

public class Claim {
    private let _name: String
    private let _value: String
    private var _valueType: ?String = None

    public init(name: String, value: String) {
        _name = name
        _value = value
    }

    public init(name: String, value: String, valueType: ?String) {
        _name = name
        _value = value
        _valueType = valueType
    }

    public prop name: String {
        get() {
            _name
        }
    }

    public prop value: String {
        get() {
            _value
        }
    }

    public prop valueType: ?String {
        get() {
            _valueType
        }
    }
}
