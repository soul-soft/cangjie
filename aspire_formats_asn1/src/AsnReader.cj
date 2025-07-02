// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

package aspire_formats_asn1

public class AsnReader {
    private let _data: Array<Byte>
    private let _ruleSet: AsnEncodingRules
    private let _options: AsnReaderOptions

    init(data: Array<Byte>, ruleSet: AsnEncodingRules, options: AsnReaderOptions) {
        _data = data
        _ruleSet = ruleSet
        _options = options
    }

    public prop hasData: Bool {
        get() {
            !_data.isEmpty()
        }
    }    
    
    public func throwIfNotEmpty() {
        if (hasData) {
            throw AsnContentException()
        }
    }

    public func peekTag(): Asn1Tag {
        if (let Some((tag, _)) <- Asn1Tag.decode(_data)) {
            return tag
        }
        throw AsnContentException()
    }

    public func PeekEncodedValue() {
        
    }
}