// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

package aspire_formats_asn1

public enum AsnEncodingRules <: Equal<AsnEncodingRules> & NotEqual<AsnEncodingRules> {
    DER
    | CER
    | BER

    public operator func ==(right: AsnEncodingRules) {
        match ((this, right)) {
            case (DER, DER) => true
            case (CER, CER) => true
            case (BER, BER) => true
            case _ => false
        }
        return true
    }

    public operator func !=(right: AsnEncodingRules) {
        !(this == right)
    }
}
