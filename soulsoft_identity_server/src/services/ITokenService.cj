package soulsoft_identity_server.services

import soulsoft_identity_server.models.*

public interface ITokenService {
    func create(token: Token): String
}