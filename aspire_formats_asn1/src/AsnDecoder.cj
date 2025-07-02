package aspire_formats_asn1

public class AsnDecoder {
    public static func readEncodedValue(
        source: Array<Byte>,
        ruleSet: AsnEncodingRules
    ) {
        checkEncodingRules(ruleSet)

        if (let Some((tag, tagLength)) <- Asn1Tag.decode(source)) {
            let (encodedLength, lengthLength) = readLength(source[tagLength..], ruleSet)
            let headerLength = tagLength + lengthLength
        }
    }

    static func checkEncodingRules(ruleSet: AsnEncodingRules) {
        if (ruleSet != AsnEncodingRules.BER && ruleSet != AsnEncodingRules.CER && ruleSet != AsnEncodingRules.DER) {
            throw IllegalArgumentException()
        }
    }

    private static func readLength(source: Array<Byte>, ruleSet: AsnEncodingRules): (?Int64, Int64) {
        let (status, length, bytesConsumed) = decodeLength(source, ruleSet)

        return match (status) {
            case LengthDecodeStatus.Success => return (length, bytesConsumed)
            case LengthDecodeStatus.LengthTooBig => throw AsnContentException()
            case LengthDecodeStatus.LaxEncodingProhibited => throw AsnContentException()
            case LengthDecodeStatus.DerIndefinite => throw AsnContentException()
            case LengthDecodeStatus.NeedMoreData => throw AsnContentException()
            case LengthDecodeStatus.ReservedValue => throw AsnContentException()
        }
    }

    private static func decodeLength(source: Array<Byte>, ruleSet: AsnEncodingRules): (LengthDecodeStatus, ?Int64, 
        Int64) {
        var length = Option<Int64>.None
        var bytesRead = 0

        if (source.isEmpty()) {
            return (LengthDecodeStatus.NeedMoreData, length, bytesRead)
        }

        let lengthOrLengthLength = source[bytesRead]
        bytesRead++
        let MultiByteMarker = 0x80u8

        if (lengthOrLengthLength == MultiByteMarker) {
            if (ruleSet == AsnEncodingRules.DER) {
                bytesRead = 0
                return (LengthDecodeStatus.DerIndefinite, length, bytesRead)
            }

            return (LengthDecodeStatus.Success, length, bytesRead)
        }

        if (lengthOrLengthLength < UInt8(MultiByteMarker)) {
            length = Int64(lengthOrLengthLength)
            return (LengthDecodeStatus.Success, length, bytesRead)
        }

        if (lengthOrLengthLength == 0xFF) {
            bytesRead = 0
            return (LengthDecodeStatus.ReservedValue, length, bytesRead)
        }

        let lengthLength = lengthOrLengthLength & (!MultiByteMarker)

        if (Int64(lengthLength) + 1 > source.size) {
            bytesRead = 0
            return (LengthDecodeStatus.NeedMoreData, length, bytesRead)
        }

        let minimalRepresentation = ruleSet == AsnEncodingRules.DER || ruleSet == AsnEncodingRules.CER

        if (minimalRepresentation && lengthLength > 4) {
            bytesRead = 0
            return (LengthDecodeStatus.LengthTooBig, length, bytesRead)
        }

        var parsedLength = 0u32

        for (i in 0..lengthLength) {
            let current = source[bytesRead]
            bytesRead++

            if (parsedLength == 0) {
                if (minimalRepresentation && current == 0) {
                    bytesRead = 0
                    return (LengthDecodeStatus.LaxEncodingProhibited, length, bytesRead)
                }

                if (!minimalRepresentation && current != 0) {
                    if (lengthLength - i > 4) {
                        bytesRead = 0
                        return (LengthDecodeStatus.LengthTooBig, length, bytesRead)
                    }
                }

                parsedLength <<= 8
                parsedLength |= UInt32(current)
            }
        }

        if (minimalRepresentation && parsedLength < UInt32(MultiByteMarker)) {
            bytesRead = 0
            return (LengthDecodeStatus.LaxEncodingProhibited, length, bytesRead)
        }

        length = Int64(parsedLength)

        return (LengthDecodeStatus.Success, length, bytesRead)
    }

    static func slice(source: Array<Byte>, offset: Int64, length: Int64) {
        if (length < 0 || source.size - offset < length) {
            throw AsnContentException()
        }

        return source.slice(offset, length)
    }

    static func slice(source: Array<Byte>, offset: Int64, length: ?Int64): Array<Byte> {
        if (let Some(lengthVal) <- length) {
            if (lengthVal < 0 || source.size - offset < lengthVal) {
                throw AsnContentException()
            }
            return source.slice(offset, lengthVal)
        } else {
            return source[offset..]
        }
    }

    internal static func checkExpectedTag(tag: Asn1Tag, expectedTag: Asn1Tag, tagNumber: UniversalTagNumber): Unit {
        if (expectedTag.tagClass == TagClass.Universal && expectedTag.tagValue != tagNumber.asByte()) {
            throw IllegalArgumentException()
        }

        if (expectedTag.tagClass != tag.tagClass || expectedTag.tagValue != tag.tagValue) {
            throw AsnContentException()
        }
    }

    internal static func readTagAndLength(source: Array<Byte>, ruleSet: AsnEncodingRules): (Asn1Tag, ?Int64, Int64) {
        if (let Some((tag, tagBytesRead)) <- Asn1Tag.decode(source)) {
            let (length, lengthBytesRead) = readLength(source[tagBytesRead..], ruleSet)

            let allBytesRead = tagBytesRead + lengthBytesRead

            if (tag.isConstructed) {
                if (ruleSet == AsnEncodingRules.CER && length.isSome()) {
                    throw AsnContentException()
                }
            } else if (length.isNone()) {
                throw AsnContentException()
            }

            return (tag, length, allBytesRead)
        }
        throw AsnContentException()
    }

    private static func validateLength(source: Array<Byte>, ruleSet: AsnEncodingRules, localTag: Asn1Tag,
        encodedLength: ?Int64) {
        if (localTag.isConstructed) {
            if (ruleSet == AsnEncodingRules.CER && encodedLength.isSome()) {
                return (LengthValidity.CerRequiresIndefinite, 0, 0)
            }
        } else if (encodedLength.isNone()) {
            return (LengthValidity.PrimitiveEncodingRequiresDefinite, 0, 0)
        }

        if (let Some(len) <- encodedLength) {
            let totalLength = len

            if (totalLength > source.size) {
                return (LengthValidity.LengthExceedsInput, 0, 0)
            }

            return (LengthValidity.Valid, len, len)
        }
        let actualLength = seekEndOfContents(source, ruleSet)
        let bytesConsumed = actualLength + Constants.EndOfContentsEncodedLength
        return (LengthValidity.Valid, actualLength, bytesConsumed)
    }

    private static func seekEndOfContents(source: Array<Byte>, ruleSet: AsnEncodingRules) {
        var cur = source
        var totalLen = 0
        var depth = 1
        while (!cur.isEmpty()) {
            let (tag, length, bytesRead) = readTagAndLength(cur, ruleSet)

            if (tag == Asn1Tag.EndOfContents) {
                validateEndOfContents(tag, length, bytesRead)

                depth--

                if (depth == 0) {
                    return totalLen
                }
            }

            if (let Some(length) <- length) {
                let tlv = cur[0..bytesRead + length]
                cur = cur[tlv.size..]
                totalLen += tlv.size
            } else {
                depth++
                cur = cur[bytesRead..]
                totalLen += bytesRead
            }
        }

        throw AsnContentException()
    }

    private static func checkExpectedTag(tag: Asn1Tag, expectedTag: Asn1Tag, tagNumber: UniversalTagNumber) {
        if (expectedTag.tagClass == TagClass.Universal && expectedTag.tagValue != tagNumber.asByte()) {
            throw IllegalArgumentException()
        }

        if (expectedTag.tagClass != tag.tagClass || expectedTag.tagValue != tag.tagValue) {
            throw AsnContentException()
        }
    }

    private static func validateEndOfContents(tag: Asn1Tag, length: ?Int64, headerLength: Int64) {
        if (tag.isConstructed || length != 0 || headerLength != Constants.EndOfContentsEncodedLength) {
            throw AsnContentException()
        }
    }
}

enum LengthDecodeStatus {
    NeedMoreData
    | DerIndefinite
    | ReservedValue
    | LengthTooBig
    | LaxEncodingProhibited
    | Success
}

enum LengthValidity {
    CerRequiresIndefinite
    | PrimitiveEncodingRequiresDefinite
    | LengthExceedsInput
    | Valid
}
