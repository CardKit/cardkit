import Foundation

public protocol JsonSerializable {
    func toSerializable() -> AnyObject
}

public func serializeBestEffort(value : Any) -> AnyObject {
    return value is JsonSerializable ? (value as! JsonSerializable).toSerializable() : String(value)
}

public func serializeBestEffortArray<T>(array : [T]) -> [AnyObject] {
    var list = [AnyObject]()
    
    for element in array {
        if element is JsonSerializable {
            list.append((element as! JsonSerializable).toSerializable())
        }
        else {
            list.append(String(element))
        }
    }
    
    return list
}

public protocol JsonParsable {
    static func fromSerializable(serialized: AnyObject) -> Any
}

public func deserializeBestEffort(type: Any.Type, serialized: AnyObject) -> Any {
    let parsable = type as? JsonParsable.Type
    return parsable == nil ? serialized : parsable!.fromSerializable(serialized)
}

