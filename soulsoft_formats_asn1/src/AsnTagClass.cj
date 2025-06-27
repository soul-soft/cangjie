// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

package soulsoft_formats_asn1

public enum AsnTagClass {
    Universal
    | Application
    | ContextSpecific
    | Private
    | Unknown(Byte)

    public static func from(byte: Byte) {
        match (byte) {
            case 0 => Universal
            case 64 => Application
            case 128 => ContextSpecific
            case 192 => Private
            case _ => Unknown(byte)
        }
    }
}
