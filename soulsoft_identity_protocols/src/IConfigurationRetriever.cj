package soulsoft_identity_protocols

public interface IConfigurationRetriever<T> {
    func getConfiguration(address: String, documentRetriever: IDocumentRetriever): T
}
