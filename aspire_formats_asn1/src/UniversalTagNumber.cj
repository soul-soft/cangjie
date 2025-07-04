// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

package aspire_formats_asn1

import std.convert.*

public enum UniversalTagNumber <: ToString & Comparable<UniversalTagNumber> {
    EndOfContents
    | Boolean
    | Integer
    | BitString
    | OctetString
    | Null
    | ObjectIdentifier
    | ObjectDescriptor
    | External
    | InstanceOf
    | Real
    | Enumerated
    | Embedded
    | UTF8String
    | RelativeObjectIdentifier
    | Time
    | ReservedIndex
    | Sequence
    | SequenceOf
    | Set
    | SetOf
    | NumericString
    | PrintableString
    | T61String
    | TeletexString
    | VideotexString
    | IA5String
    | UtcTime
    | GeneralizedTime
    | GraphicString
    | ISO646String
    | VisibleString
    | GeneralString
    | UniversalString
    | UnrestrictedCharacterString
    | BMPString
    | Date
    | TimeOfDay
    | DateTime
    | Duration
    | ObjectIdentifierIRI
    | RelativeObjectIdentifierIRI

    public func asByte() {
        match (this) {
            case EndOfContents => 0
            case Boolean => 1
            case Integer => 2
            case BitString => 3
            case OctetString => 4
            case Null => 5
            case ObjectIdentifier => 6
            case ObjectDescriptor => 7
            case External => 8
            case InstanceOf => 8
            case Real => 9
            case Enumerated => 10
            case Embedded => 11
            case UTF8String => 12
            case RelativeObjectIdentifier => 13
            case Time => 14
            case ReservedIndex => 15
            case Sequence => 16
            case SequenceOf => 16
            case Set => 17
            case SetOf => 17
            case NumericString => 18
            case PrintableString => 19
            case T61String => 20
            case TeletexString => 20
            case VideotexString => 21
            case IA5String => 22
            case UtcTime => 23
            case GeneralizedTime => 24
            case GraphicString => 25
            case ISO646String => 26
            case VisibleString => 26
            case GeneralString => 27
            case UniversalString => 28
            case UnrestrictedCharacterString => 29
            case BMPString => 30
            case Date => 31
            case TimeOfDay => 32
            case DateTime => 33
            case Duration => 34
            case ObjectIdentifierIRI => 35
            case RelativeObjectIdentifierIRI => 36
        }
    }

    public func toString() {
        "0X (${asByte().format("02X")})"
    }

    public func compare(right: UniversalTagNumber): Ordering {
        let value1 = this.asByte()
        let value2 = right.asByte()
       
        if (value1 == value2) {
            Ordering.EQ
        } else if (value1 >= value2) {
            Ordering.GT
        } else {
            Ordering.LT
        }
    }
}
