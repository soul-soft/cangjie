package aspire_extensions_options

public interface IOptionsMonitor<TOptions> where TOptions <: Object {
    prop currentValue: TOptions
    func get(name: String): TOptions
}
