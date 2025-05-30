package soulsoft_extensions_options

public interface IOptions<TOptions> where TOptions <: Object {
    prop value: TOptions
    func get(name: String): TOptions
}