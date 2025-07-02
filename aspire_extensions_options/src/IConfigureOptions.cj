package aspire_extensions_options

public interface IConfigureOptions<TOptions> where TOptions <: Object {
    func configure(name: String, options: TOptions): Unit
}


