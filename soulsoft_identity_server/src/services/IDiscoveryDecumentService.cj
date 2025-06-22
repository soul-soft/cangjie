package soulsoft_identity_server.services

public interface IDiscoveryDecumentService {
    func createJwksDocument() : String
    func createDiscoveryDocument(): String
}