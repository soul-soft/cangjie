package soulsoft_extensions_configuration

public interface IConfigurationRoot <: IConfiguration {
    prop providers: Collection<IConfigurationProvider>
}
