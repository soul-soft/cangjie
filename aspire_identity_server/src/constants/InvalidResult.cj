package aspire_identity_server.constants

import stdx.serialization.serialization.*

public class InvalidResult <: Serializable<InvalidResult> {
    public InvalidResult(let error: String, let errorDescription: String) {
    }

    public func serialize(): DataModel {
        let dms = DataModelStruct()
        dms.add(Field("error", DataModelString(error)))
        dms.add(Field("error_description", DataModelString(errorDescription)))
        return dms
    }

    public static func deserialize(dm: DataModel): InvalidResult {
        let dms = match (dm) {
            case data: DataModelStruct => data
            case _ => throw Exception("this data is not DataModelStruct")
        }
        let error = String.deserialize(dms.get("name"))
        let errorDescription = String.deserialize(dms.get("error_description"))
        return InvalidResult(error, errorDescription)
    }
}
