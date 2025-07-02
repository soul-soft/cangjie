package aspire_extensions_options

public interface IOptions<TOptions> where TOptions <: Object {
    prop value: TOptions
}