package aspire_extensions_options

class OptionsMonitor<TOptions> <: IOptionsMonitor<TOptions> where TOptions <: Object {
    private let _optionsFactory: IOptionsFactory<TOptions>

    public init(optionsFactory: IOptionsFactory<TOptions>) {
        _optionsFactory = optionsFactory
    }

    public func get(name: String): TOptions {
        _optionsFactory.create(name)
    }

    public prop currentValue: TOptions {
        get() {
            get(Options.defaultName)
        }
    }
}
