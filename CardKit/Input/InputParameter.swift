import Foundation

public protocol InputParameter : JsonSerializable, JsonParsable {
}

extension Int : InputParameter {
    public func toSerializable() -> AnyObject {
        return self
    }
    
    public static func fromSerializable(serialized: AnyObject) -> Any {
        return serialized
    }
}

extension Double : InputParameter {
    public func toSerializable() -> AnyObject {
        return self
    }
    
    public static func fromSerializable(serialized: AnyObject) -> Any {
        return serialized
    }
}

extension String : InputParameter {
    public func toSerializable() -> AnyObject {
        return self
    }
    
    public static func fromSerializable(serialized: AnyObject) -> Any {
        return serialized
    }
}