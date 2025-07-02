package aspire_identity_protocols

public interface IDocumentRetriever {
    func getDocument(address: String): String
}