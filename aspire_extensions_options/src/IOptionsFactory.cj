package aspire_extensions_options

public interface IOptionsFactory<TOptions> where TOptions <: Object {
    func create(name: String): TOptions
}