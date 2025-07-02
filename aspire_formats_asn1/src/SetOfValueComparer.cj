package aspire_formats_asn1

class SetOfValueComparer <: Comparable<Array<Byte>> {
    
    public func compare(right: Array<Byte>) {
        if(this == right) {
            Ordering.EQ
        }
        else if(this > right) {
            Ordering.GT
        }
        else {
             Ordering.LT
        }
    }
}