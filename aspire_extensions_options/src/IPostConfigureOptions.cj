package aspire_extensions_options

public interface IPostConfigureOptions<TOptions> where TOptions <: Object {
    func postConfigure(name: String, options: TOptions): Unit
}


