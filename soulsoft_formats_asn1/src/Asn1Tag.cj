// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

package soulsoft_formats_asn1

import std.math.numeric.*

public class Asn1Tag <: Equal<Asn1Tag> & NotEqual<Asn1Tag> {
    private let _tagValue: Int64
    private let _controlFlags: Byte

    public init(controlFlags: Byte, tagValue: Int64) {
        _tagValue = tagValue
        _controlFlags = controlFlags
    }

    public init(universalTagNumber: UniversalTagNumber, isConstructed!: Bool = false) {
        this(if (isConstructed) {
            ConstructedMask
        } else {
            0
        }, universalTagNumber.asByte())

        if (universalTagNumber < UniversalTagNumber.EndOfContents || universalTagNumber > UniversalTagNumber
            .RelativeObjectIdentifierIRI || universalTagNumber == ReservedIndex) {
            throw IllegalArgumentException("universalTagNumber")
        }
    }

    public func calculateEncodedSize() {
        let SevenBits = 0b0111_1111
        let FourteenBits = 0b0011_1111_1111_1111
        let TwentyOneBits = 0b0001_1111_1111_1111_1111_1111
        let TwentyEightBits = 0b0000_1111_1111_1111_1111_1111_1111_1111

        if (tagValue < Int64(TagNumberMask)) {
            return 1
        }
        if (tagValue <= SevenBits) {
            return 2
        }
        if (tagValue <= FourteenBits) {
            return 3
        }
        if (tagValue <= TwentyOneBits) {
            return 4
        }
        if (tagValue <= TwentyEightBits) {
            return 5
        }

        return 6
    }

    public func AsPrimitive(): Asn1Tag {
        return Asn1Tag((_controlFlags & (!ConstructedMask)), tagValue)
    }

    public func asConstructed() {
        return Asn1Tag(_controlFlags | ConstructedMask, tagValue)
    }

    public static func decode(source: Array<Byte>): ?(Asn1Tag, Int64) {
        var bytesConsumed = 0
        if (source.isEmpty()) {
            return None
        }

        let first = source[bytesConsumed]
        bytesConsumed++
        var tagValue = first & TagNumberMask

        if (tagValue == TagNumberMask) {
            let ContinuationFlag = 0x80u8
            let ValueMask = ContinuationFlag - 1

            tagValue = 0

            var current = 0u8

            do {
                if (source.size <= bytesConsumed) {
                    bytesConsumed = 0
                    return None
                }

                current = source[bytesConsumed]
                let currentValue = current & ValueMask
                bytesConsumed++
                
                let TooBigToShift = 0b00000010_00000000_00000000_00000000

                if (Int64(tagValue) >= TooBigToShift) {
                    bytesConsumed = 0
                    return None
                }

                tagValue <<= 7
                tagValue |= currentValue

                if (tagValue == 0) {
                    bytesConsumed = 0
                    return None
                }
                
            } while ((current & ContinuationFlag) == ContinuationFlag)

            if (Int32(tagValue) > Int32.Max) {
                bytesConsumed = 0
                return None
            }
        }

        let tag = Asn1Tag(first, Int64(tagValue))
        return (tag, bytesConsumed)
    }

    public func encode(destination: Array<Byte>): ?Int64 {
        let spaceRequired = calculateEncodedSize()
        if (destination.size < spaceRequired) {
            return None
        }

        if (spaceRequired == 1) {
            let value = Int64(_controlFlags) | tagValue
            destination[0] = UInt8(value)
            return 1
        }

        let firstByte = _controlFlags | TagNumberMask
        destination[0] = firstByte

        var remaining = tagValue
        var idx = spaceRequired - 1

        while (remaining > 0) {
            var segment = remaining & 0x7F

            if (remaining != tagValue) {
                segment |= 0x80
            }

            destination[idx] = UInt8(segment)
            remaining >>= 7
            idx++
        }

        return spaceRequired
    }

    public operator func ==(oth: Asn1Tag) {
        _tagValue == oth._tagValue && _controlFlags == oth._controlFlags
    }

    public operator func !=(oth: Asn1Tag) {
        !(this == oth)
    }

    public prop tagClass: TagClass {
        get() {
            TagClass.from(_controlFlags & ControlMask)
        }
    }

    public prop tagValue: Int64 {
        get() {
            _tagValue
        }
    }

    public prop isConstructed: Bool {
        get() {
            (_controlFlags & ConstructedMask) != 0
        }
    }

    //consts
    private static let ClassMask: Byte = 0b1100_0000
    private static let ConstructedMask: Byte = 0b0010_0000
    private static let TagNumberMask: Byte = 0b0001_1111
    private static let ControlMask: Byte = ClassMask | ConstructedMask
    //Asn1Tag consts
    internal static let EndOfContents = Asn1Tag(0, UniversalTagNumber.EndOfContents.asByte())
    internal static let Boolean = Asn1Tag(0, UniversalTagNumber.Boolean.asByte())
    internal static let Integer = Asn1Tag(0, UniversalTagNumber.Integer.asByte())
    internal static let PrimitiveBitString = Asn1Tag(0, UniversalTagNumber.BitString.asByte())
    internal static let ConstructedBitString = Asn1Tag(ConstructedMask, UniversalTagNumber.BitString.asByte())
    internal static let PrimitiveOctetString = Asn1Tag(0, UniversalTagNumber.OctetString.asByte())
    internal static let ConstructedOctetString = Asn1Tag(ConstructedMask, UniversalTagNumber.OctetString.asByte())
    internal static let Null = Asn1Tag(0, UniversalTagNumber.Null.asByte())
    internal static let ObjectIdentifier = Asn1Tag(0, UniversalTagNumber.ObjectIdentifier.asByte())
    internal static let Enumerated = Asn1Tag(0, UniversalTagNumber.Enumerated.asByte())
    internal static let Sequence = Asn1Tag(ConstructedMask, UniversalTagNumber.Sequence.asByte())
    internal static let SetOf = Asn1Tag(ConstructedMask, UniversalTagNumber.SetOf.asByte())
    internal static let UtcTime = Asn1Tag(0, UniversalTagNumber.UtcTime.asByte())
    internal static let GeneralizedTime = Asn1Tag(0, UniversalTagNumber.GeneralizedTime.asByte())
}
