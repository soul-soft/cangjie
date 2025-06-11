package soulsoft_extensions_configuration

import std.collection.*

func getChildKeys(configuratin: IConfigurationRoot, parentPath: ?String): Iterable<String> {
    let results = HashSet<String>()
    let providers = configuratin.providers |> collectArray
    var index = providers.size - 1
    while (index >= 0) {
        let provider = providers[index]
        let keys = provider.getChildKeys(results |> collectArray, parentPath)
        for (pattern in keys) {
            if (!results.contains(pattern)) {
                results.add(pattern)
            }
        }
        index--
    }
    return results |> collectArray
}


func camelCase(name: String, splitter: String) {
    let sb = StringBuilder()
    for ((index, pattern) in name.toAsciiLower().split(splitter, removeEmpty: true) |> enumerate) {
        let bytes = pattern.toArray()
        if (index == 0) {
            sb.append(pattern)
        }else {
            bytes[0] = bytes[0].toAsciiUpperCase()
            sb.append(String.fromUtf8(bytes))
        }
    }
    return sb.toString().trimStart().trimEnd()
}
