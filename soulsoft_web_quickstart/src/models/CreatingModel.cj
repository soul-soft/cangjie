package soulsoft_web_quickstart.models

import stdx.serialization.serialization.*

public class CreatingModel <: Serializable<CreatingModel> {
    public var id = 0
    public var name = String.empty

    public static func deserialize(dm: DataModel): CreatingModel {
        let model = CreatingModel()
        if (let dms: DataModelStruct <- dm) {
            if (let id: DataModelInt <- dms.get('id')) {
                model.id = id.getValue()
            }
            if (let name: DataModelString <- dms.get('name')) {
                model.name = name.getValue()
            }
        }
        return model
    }

    public func serialize(): DataModel {
        let dms = DataModelStruct()
        dms.add(Field("id", DataModelInt(id)))
        dms.add(Field("name", DataModelString(name)))
        return dms
    }
}