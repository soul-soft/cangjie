package aspire_identity_protocols_oidc

import stdx.serialization.serialization.*

extend DataModelStruct {
    public func add(name: String, value: String, flag: Bool) {
        if (flag) {
            this.add(Field(name, value.serialize()))
        }
    }

    public func add(name: String, value: Bool, flag!: Bool = true) {
        if (flag) {
            this.add(Field(name, value.serialize()))
        }
    }

    public func add(name: String, value: Int64, flag!: Bool = true) {
        if (flag) {
            this.add(Field(name, value.serialize()))
        }
    }
    
    public func add(name: String, values: Collection<String>, flag: Bool) {
        if (flag) {
            let seq = DataModelSeq()
            for (pattern in values) {
                seq.add(pattern.serialize())
            }
            this.add(Field(name, seq))
        }
    }
}