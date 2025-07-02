package aspire_extensions_options

class ConfigureOptions<TOptions> <: IConfigureOptions<TOptions> where TOptions <: Object {
    private let _name: String
    private let _configure: (TOptions) -> Unit

    init(name: String, configure: (TOptions) -> Unit) {
        _name = name
        _configure = configure
    }

    public func configure(name: String, options: TOptions) {
        if (name == _name) {
            _configure(options)
        }
    }
}