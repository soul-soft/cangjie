package aspire_extensions_options

public class OptionsWrapper<TOptions> <: IOptions<TOptions> where TOptions <: Object {
    private let _value: TOptions
    
    public init(options: TOptions) {
        _value = options
    }

    public prop value: TOptions {
        get() {
            _value
        }
    }
}