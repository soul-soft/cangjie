package soulsoft_extensions_configuration

public interface IConfigurationSource {
    func build(builder: IConfigurationBuilder): IConfigurationProvider
}
