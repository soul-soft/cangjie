package soulsoft_web_authentication

import std.time.*
import std.collection.*

public class AuthenticationProperties {
    private let _items: HashMap<String, Any>
    static let _tokenNamesKey = ".TokenNames"
    static let _tokenKeyPrefix = ".Token."

    public init(items: HashMap<String, Any>) {
        _items = items
    }

    public init() {
        this(HashMap<String, Any>())
    }

    public prop items: HashMap<String, Any> {
        get() {
            _items
        }
    }
}

extend AuthenticationProperties {
    public func storeTokens(tokens: Array<AuthenticationToken>) {
        for (token in getTokens()) {
            items.remove("${_tokenKeyPrefix}${token.name}")
        }
        items.remove(_tokenNamesKey)

        let tokenNames = ArrayList<String>()
        for (token in tokens) {
            if (token.name.isEmpty()) {
                throw IllegalArgumentException("Token name cannot be null for any token.")
            }
            tokenNames.add(token.name)
            items["${_tokenKeyPrefix}${token.name}"] = token.value
        }
        
        if (tokenNames.size > 0) {
            items[_tokenNamesKey] = tokenNames |> collectArray
        }
    }

    public func updateTokenValue(tokenName: String, tokenValue: String) {
        let tokenKey = "${_tokenKeyPrefix}${tokenName}"
        if (!items.contains(tokenKey)) {
            return false
        }

        items[tokenKey] = tokenValue
        return true
    }

    public func getTokens(): Collection<AuthenticationToken> {
        
        let tokens = ArrayList<AuthenticationToken>()

        if (let Some(tokenNames) <- items.get(_tokenNamesKey).flatMap{f => f as Array<String>}) {
            for (tokenName in tokenNames) {
                if (let Some(tokenValue) <- getTokenValue(tokenName)) {
                    tokens.add(AuthenticationToken(tokenName, tokenValue))
                }
            }
        }

        return tokens
    }

    public func getTokenValue(tokenName: String): ?String {
        items.get("${_tokenKeyPrefix}${tokenName}").flatMap{f => f as String}
    }
}
