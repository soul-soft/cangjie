package aspire_extensions_options

class UnnamedOptionsManager<TOptions> <: IOptions<TOptions> where TOptions <: Object {
    private let _optionsFactory: IOptionsFactory<TOptions>

    public init(optionsFactory: IOptionsFactory<TOptions>) {
        _optionsFactory = optionsFactory
    }

    public prop value: TOptions {
        get() {
            _optionsFactory.create(Options.defaultName)
        }
    }

    public func get(name: String): TOptions {
        _optionsFactory.create(name)
    }
}