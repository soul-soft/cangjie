package soulsoft_extensions_options

public interface IConfigureAfterOptions<TOptions> where TOptions <: Object {
    func configureAfter(name: String, options: TOptions): Unit
}


