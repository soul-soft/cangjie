package soulsoft_extensions_configuration

/*
配置核心接口
 */
public interface IConfiguration {
    operator func [](name: String): ?String
    operator func [](name: String, value!: ?String): Unit
    func getSection(key: String): IConfigurationSection
    func getChildren(): Collection<IConfigurationSection>
}
