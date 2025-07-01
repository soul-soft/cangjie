package soulsoft_web.authentication

import std.collection.*

public interface IResourceOwnerPasswordValidator {
    func validate(username: String, password: String): Bool
}

public class ResourceOwnerPasswordValidator <: IResourceOwnerPasswordValidator {
    let users = HashMap<String, String>([("soulsoft", "soulsoft")])

    public func validate(username: String, password: String) {
        if (!users.contains(username)) {
            return false
        }
        return users[username] == password
    }
}
