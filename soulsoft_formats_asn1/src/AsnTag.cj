// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

package soulsoft_formats_asn1

private let ClassMask: Byte = 0b1100_0000
private let ConstructedMask: Byte = 0b0010_0000
private let TagNumberMask: Byte = 0b0001_1111
private let ControlMask: Byte = ClassMask | ConstructedMask

public class AsnTag {
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
        }, universalTagNumber.value())

        if (universalTagNumber < UniversalTagNumber.EndOfContents ||
            universalTagNumber > UniversalTagNumber.RelativeObjectIdentifierIRI ||
            universalTagNumber == ReservedIndex)
        {
            throw IllegalArgumentException("universalTagNumber")
        }
    }

    public prop tagClass: AsnTagClass {
        get() {
            AsnTagClass.from(_controlFlags & ControlMask)
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
}
