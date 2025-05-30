package soulsoft_extensions_options

class ConfigureAfterOptions<TOptions> <: IConfigureAfterOptions<TOptions> where TOptions <: Object {
    private let _name: String
    private let _configure: (TOptions) -> Unit

    init(name: String, configure: (TOptions) -> Unit) {
        _name = name
        _configure = configure
    }

    public func configureAfter(name: String, options: TOptions) {
        if (name == _name) {
            _configure(options)
        }
    }
}