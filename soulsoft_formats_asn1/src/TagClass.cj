// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

package soulsoft_formats_asn1

public enum TagClass <: ToString & Equal<TagClass> {
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

    public operator func ==(oth: TagClass) {
        match ((this, oth)) {
            case (Universal, Universal) => true
            case (Application, Application) => true
            case (ContextSpecific, ContextSpecific) => true
            case (Private, Private) => true
            case (Unknown(x), Unknown(y)) => x == y
            case _ => false
        }
    }

    public operator func !=(oth: TagClass) {
        !(this == oth)
    }

    public func toString() {
        match (this) {
            case Universal => "Universal"
            case Application => "Application"
            case ContextSpecific => "ContextSpecific"
            case Private => "Private"
            case Unknown(byte) => "Unknown(${byte})"
        }
    }
}
