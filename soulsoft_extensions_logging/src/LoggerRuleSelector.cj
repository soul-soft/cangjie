package soulsoft_extensions_logging

import std.reflect.TypeInfo

class LoggerRuleSelector {
    
    private static let _wildcardChar = '*';

    public static func select(options: LoggerFilterOptions, providerName: String, categoryName: String) {
        var filter: ?LoggerFilter = None
        var minLevel: ?LogLevel = options.minLevel
        var current: ?LoggerFilterRule = None
        for (rule in options.rules) {
            if (isBetter(rule, current, providerName, categoryName)) {
                current = rule
            }
        }
        if (let Some(rule) <- current) {
            filter = rule.filter
            minLevel = rule.logLevel
        }
      
        return (minLevel, filter)
    }

    private static func isBetter(rule: LoggerFilterRule, current: ?LoggerFilterRule, providerName: String, categoryName: String) {

        if (rule.providerName != None && rule.providerName != providerName) {
            return false
        }    

        if (let Some(category) <- rule.categoryName) {
            let wildcardIndex = category.indexOf(_wildcardChar)
            if (wildcardIndex != None && category.indexOf(_wildcardChar, (wildcardIndex ?? -1) + 1) != None) {
                throw UnsupportedException("More Than One '${_wildcardChar}'");
            }
            var prefix = category.toAsciiLower()
            var suffix = String.empty
            if (let Some(index) <- wildcardIndex) {
                prefix = category[0..index].toAsciiLower()
                suffix = category[(index + 1)..].toAsciiLower()
            }
            let categoryNameAsciiLower = categoryName.toAsciiLower()
            if (!categoryNameAsciiLower.startsWith(prefix) || !categoryNameAsciiLower.endsWith(suffix)) {
                return false;
            }
        } 
       
        if (let Some(Some(_)) <- current?.providerName) {
            if (rule.providerName == None) {
                return false
            }
        } else {
            if (rule.providerName != None) {
                return true
            }
        }

        if (!current.isNone() && (let Some(category) <- current.getOrThrow().categoryName)) {
            if (rule.categoryName.isNone()) {
                return false;
            }

            if (category.size > rule.categoryName.getOrThrow().size) {
                return false;
            }
        }
        return true
    }
}
