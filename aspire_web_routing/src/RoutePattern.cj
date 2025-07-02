package aspire_web_routing

import std.collection.*

public class RoutePattern <: ToString {
    private let _rawText: String
    private let _segments: Array<String>
    private let _parameters: HashMap<String, String>

    init(rawText: String, segments: Array<String>, parameters: HashMap<String, String>) {
        _rawText = rawText
        _segments = segments
        _parameters = parameters
    }

    public prop rawText: String {
        get() {
            _rawText
        }
    }

    public prop segments: Array<String> {
        get() {
            _segments
        }
    }

    public prop parameters: HashMap<String, String> {
        get() {
            _parameters
        }
    }

    public func toString() {
        _rawText
    }

    public static func parse(path: String) {
        let segments = path.split('/', removeEmpty: true)
        let rawText = String.join(segments, delimiter: '/')
        let parameters = HashMap<String, String>()
        for (pattern in segments) {
            if (pattern.startsWith('{') && pattern.endsWith('}')) {
                parameters.add(pattern, pattern[1..pattern.size - 1])
            }
        }
        return RoutePattern(rawText, segments, parameters)
    }
}
