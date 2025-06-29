package soulsoft_formats_asn1

import std.collection.*

extend AsnDecoder {
    public static func readPrimitiveBitString(source: Array<Byte>, ruleSet: AsnEncodingRules) {
        readPrimitiveBitString(source, ruleSet, Asn1Tag.PrimitiveBitString)
    }

    public static func readPrimitiveBitString(source: Array<Byte>, ruleSet: AsnEncodingRules, expectedTag: Asn1Tag): ?(Array<Byte>,Int64, Int64) {
        if (let Some((localValue, _, _, localUbc, consumed, normalizedLastByte)) <- readPrimitiveBitStringCore(source, ruleSet, expectedTag)) {
            if (localValue.size == 0 || normalizedLastByte == localValue[localValue.size - 1]) {
                return (localValue, localUbc, consumed)
            }
        }
        return None
    }

    public static func readBitString(source: Array<Byte>, destination: Array<Byte>, ruleSet: AsnEncodingRules) {
        readBitString(source, destination, ruleSet, Asn1Tag.PrimitiveBitString)
    }

    public static func readBitString(source: Array<Byte>, destination: Array<Byte>, ruleSet: AsnEncodingRules, expectedTag: Asn1Tag):?(Int64,Int64,Int64) {
        if (let Some((value,contentsLength, headerLength, localUbc, consumed, normalizedLastByte)) <- readPrimitiveBitStringCore(source, ruleSet, expectedTag)) {
            if (value.size > destination.size) {
                return None
            }

            copyBitStringValue(value, normalizedLastByte, destination)

            return (localUbc,consumed,value.size)
        }

        return None
    }

    private static func readPrimitiveBitStringCore(source: Array<Byte>, ruleSet: AsnEncodingRules, expectedTag: Asn1Tag): ?(Array<Byte>, 
        ?Int64, Int64, Int64, Int64, Byte) {
        let (actualTag, contentsLength, headerLength) = readTagAndLength(source, ruleSet)

        checkExpectedTag(actualTag, expectedTag, UniversalTagNumber.BitString)

        let encodedValue = slice(source, headerLength, contentsLength)

        if (actualTag.isConstructed) {
            if (ruleSet == AsnEncodingRules.DER) {
                throw AsnContentException()
            }
            return None
        }

        let (value, unusedBitCount, normalizedLastByte) = parsePrimitiveBitStringContents(encodedValue, ruleSet)
        let bytesConsumed = headerLength + encodedValue.size

        return (value, contentsLength, headerLength, unusedBitCount, bytesConsumed, normalizedLastByte)
    }

    private static func copyBitStringValue(value: Array<Byte>, normalizedLastByte: Byte, destination: Array<Byte>): Unit {
        if (value.size == 0) {
            return
        }
        value.copyTo(normalizedLastByte)
        destination[value.size - 1] = normalizedLastByte
    }

    private static func copyConstructedBitStringValue(source: Array<Byte>, ruleSet: AsnEncodingRules, dest: Array<Byte>, isIndefinite: Bool) {
        countConstructedBitString(source, ruleSet, dest)
    }

    private static func countConstructedBitString(source: Array<Byte>, ruleSet: AsnEncodingRules, isIndefinite: Bool) {
        let (total,_, _) = processConstructedBitString(source, ruleSet, [], None, isIndefinite)
        return total
    }

    private static func processConstructedBitString(source: Array<Byte>, ruleSet: AsnEncodingRules, destination: Array<Byte>, copyAction: ?BitStringCopyAction, _isIndefinite: Bool): (Int64, Int64, Int64) {
        var bytesRead = 0
        let lastUnusedBitCount = 0
        var lastSegmentLength = Constants.MaxCERSegmentSize
        var isIndefinite = _isIndefinite
        var cur = source
        var readerStack :?ArrayStack<(offset: Int64, length: Int64,indefinite: Bool,bytesRead: Int64)> = None
        var totalLength = 0
        var tag = Asn1Tag.ConstructedBitString
        var curDest = destination
        while (true) {
            while (!cur.isEmpty()) {
                var headerLength = 0
                var length = Option<Int64>.None
                (tag, length, headerLength) = readTagAndLength(cur, ruleSet)
                if (tag == Asn1Tag.PrimitiveBitString) {
                    if (lastUnusedBitCount != 0) {
                        throw AsnContentException()
                    }

                    if (ruleSet == AsnEncodingRules.CER && lastSegmentLength != Constants.MaxCERSegmentSize) {
                        throw AsnContentException()
                    }

                    let encodedValue = slice(cur, headerLength, length.getOrThrow())

                    let (contents, lastUnusedBitCount, normalizedLastByte) = parsePrimitiveBitStringContents(encodedValue, ruleSet)

                    let localLen = headerLength + encodedValue.size
                    cur = cur[localLen..]
                    bytesRead += localLen
                    totalLength += contents.size
                    lastSegmentLength = encodedValue.size

                    if (let Some(copyAction) <- copyAction) {
                        copyAction(contents, normalizedLastByte, curDest)
                        curDest = curDest[contents.size..]
                    }
                } else if(tag == Asn1Tag.EndOfContents && isIndefinite){
                    validateEndOfContents(tag, length, headerLength)

                    bytesRead += headerLength

                    if (let Some(readerStack) <- readerStack && readerStack.size > 0) {
                        let (topOffset, topLength, wasIndefinite, pushedBytesRead) = readerStack.remove().getOrThrow()
                        let topSpan = source.slice(topOffset, topLength)
                        cur = topSpan[bytesRead..]

                        bytesRead += pushedBytesRead
                        isIndefinite = wasIndefinite
                    }else {
                        break
                    }
                }else if(tag == Asn1Tag.ConstructedBitString) {
                    if (ruleSet == AsnEncodingRules.CER) {
                        throw AsnContentException()
                    }

                    readerStack = readerStack ?? ArrayStack<(Int64, Int64, Bool, Int64)>()

                    if (!source.overlaps(cur)) {
                        throw AsnContentException()
                    }
                    
                    readerStack?.add((cur, cur.size, isIndefinite, bytesRead))

                }else {
                    throw AsnContentException()
                }
            }
        }
        return (0,0,0)
    }

    private static func validateEndOfContents(tag: Asn1Tag, length: ?Int64, headerLength: Int64) {
        if (tag.isConstructed || length != 0 || headerLength != Constants.EndOfContentsEncodedLength) {
            throw AsnContentException()
        }
    }

    private static func parsePrimitiveBitStringContents(source: Array<Byte>, ruleSet: AsnEncodingRules): (Array<Byte>, Int64, Byte) {
        if (ruleSet == AsnEncodingRules.CER && source.size > Constants.MaxCERSegmentSize) {
            throw AsnContentException()
        }

        if (source.size == 0) {
            throw AsnContentException()
        }

        let unusedBitCount = source[0]

        if (unusedBitCount > 7) {
            throw AsnContentException()
        }

        if (source.size == 1) {
            if (unusedBitCount > 0) {
                throw AsnContentException()
            }
            return ([], Int64(unusedBitCount), 0)
        }

        let mask = -1 << Int64(unusedBitCount)

        let lastByte = source[source.size - 1]
        let maskedByte = UInt8(Int64(lastByte) & mask)

        if (maskedByte != lastByte) {
            if (ruleSet == AsnEncodingRules.DER || ruleSet == AsnEncodingRules.CER) {
                throw AsnContentException()
            }
        }
        let value = source[1..]
        let normalizedLastByte = maskedByte
        return (value, Int64(unusedBitCount), normalizedLastByte)
    }
}


type BitStringCopyAction = (Array<Byte>, Byte, Array<Byte>) -> Unit