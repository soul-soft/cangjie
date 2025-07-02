package aspire_web_mvc.bindings

import std.time.*
import std.reflect.*
import std.convert.*
import std.collection.*
import stdx.encoding.url.*
import aspire_web_http.*
import stdx.serialization.serialization.*

private let FLOAT_TYPE_NAMES = ["Float64", "Float32", "Float16"]
private let INTEGER_TYPE_NAMES = ["Int64", "Int32", "Int16", "Int8", "UInt64", "UInt32", "UInt16", "UInt8"]

public abstract class ModelBindingHelper {
    public static func deserization(typeInfo: TypeInfo, dm: DataModel) {
        let converter = typeInfo.getStaticFunction("deserialize", TypeInfo.of<DataModel>())
        return converter.apply(typeInfo, dm)
    }

    public static func deserization(parameterInfo: ParameterInfo, form: Form) {
        if (let classTypeInfo: ClassTypeInfo <- parameterInfo.typeInfo) {
            let dms = DataModelStruct()
            for (pattern in classTypeInfo.instanceVariables) {
                if (let Some(value) <- form.get(pattern.name)) {
                    addDataModelField(dms, pattern.name, value, pattern.typeInfo)
                }
            }
            return deserization(parameterInfo.typeInfo, dms)
        } else {
            if (let Some(value) <- form.get(parameterInfo.name)) {
                parseValue(value, parameterInfo.typeInfo)
            }
        }
        throw ModelBindingException("${parameterInfo}:binding fait")
    }

    public static func deserization(parameterInfo: ParameterInfo, routeValues: RouteValues) {
        if (let classTypeInfo: ClassTypeInfo <- parameterInfo.typeInfo) {
            let dms = DataModelStruct()
            for (pattern in classTypeInfo.instanceVariables) {
                if (let Some(value) <- routeValues.get(pattern.name)) {
                    addDataModelField(dms, pattern.name, value, pattern.typeInfo)
                }
            }
            return deserization(parameterInfo.typeInfo, dms)
        } else {
            if (let Some(value) <- routeValues.get(parameterInfo.name)) {
                return parseValue(value, parameterInfo.typeInfo)
            }
        }
        throw ModelBindingException("${parameterInfo}:binding fait")
    }

    private static func addDataModelField(dms: DataModelStruct, name: String, value: String, typeInfo: TypeInfo): Unit {
        if (FLOAT_TYPE_NAMES.contains(typeInfo.name)) {
            dms.add(Field(name, DataModelFloat(Float64.parse(value))))
        } else if (INTEGER_TYPE_NAMES.contains(typeInfo.name)) {
            dms.add(Field(name, DataModelInt(Int64.parse(value))))
        } else if (typeInfo.name == "Bool") {
            dms.add(Field(name, DataModelBool(Bool.parse(value))))
        } else if (typeInfo.name == "String") {
            dms.add(Field(name, DataModelString(value)))
        }
    }

    private static func parseValue(value: String, typeInfo: TypeInfo): Any {
        if (typeInfo.name == "Float64") {
            return Float64.parse(value)
        } else if (typeInfo.name == "Float32") {
            return Float32.parse(value)
        } else if (typeInfo.name == "Float16") {
            return Float16.parse(value)
        } else if (typeInfo.name == "Int64") {
            return Int64.parse(value)
        } else if (typeInfo.name == "Int32") {
            return Int32.parse(value)
        } else if (typeInfo.name == "Int16") {
            return Int16.parse(value)
        } else if (typeInfo.name == "Int8") {
            return Int8.parse(value)
        } else if (typeInfo.name == "UInt64") {
            return UInt64.parse(value)
        } else if (typeInfo.name == "UInt32") {
            return UInt32.parse(value)
        } else if (typeInfo.name == "UInt16") {
            return UInt16.parse(value)
        } else if (typeInfo.name == "UInt8") {
            return UInt8.parse(value)
        } else if (typeInfo.name == "Bool") {
            return Bool.parse(value)
        } else if (typeInfo.name == "DateTime") {
            return DateTime.parse(value)
        } else if (typeInfo.name == "String") {
            return value
        }
        return value
    }
}
