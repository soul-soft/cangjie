package soulsoft_identity_protocols

public interface IConfigurationManager<T> {
    func refresh(): Unit
    func getConfiguration(): T
}