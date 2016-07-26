import Foundation

public struct InputCoordinate2D : InputParameter {
    public let latitude : Double
    public let longitude : Double
    
    public init(latitude : Double, longitude : Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    public func toSerializable() -> AnyObject {
        var dict = [String: Double]()
        dict["latitude"]    = latitude
        dict["longitude"]   = longitude
        return dict
    }
    
    public static func fromSerializable(serialized: AnyObject) -> Any {
        return InputCoordinate2D(
            latitude: serialized["latitude"] as! Double,
            longitude: serialized["longitude"] as! Double)
    }
}

public struct InputCoordinate2DPath : InputParameter {
    public let path : [InputCoordinate2D]
    
    public init(path : [InputCoordinate2D]) {
        self.path = path
    }
    
    public func toSerializable() -> AnyObject {
        var list = [AnyObject]()
        
        for hop in path {
            list.append(hop.toSerializable())
        }
        
        return list
    }
    
    public static func fromSerializable(serialized: AnyObject) -> Any {
        var list = [InputCoordinate2D]()
        
        for hop in serialized as! [AnyObject] {
            list.append(InputCoordinate2D.fromSerializable(hop) as! InputCoordinate2D)
        }
        
        return InputCoordinate2DPath(path: list)
    }
}

public struct InputCoordinate3D : InputParameter {
    public let latitude : Double
    public let longitude : Double
    public let altitudeMeters : Double
    
    public init(latitude : Double, longitude : Double, altitudeMeters : Double) {
        self.latitude = latitude
        self.longitude = longitude
        self.altitudeMeters = altitudeMeters
    }
    
    public func toSerializable() -> AnyObject {
        var dict = [String: Double]()
        dict["latitude"] = latitude
        dict["longitude"] = longitude
        dict["altitudeMeters"] = altitudeMeters
        return dict
    }
    
    public static func fromSerializable(serialized: AnyObject) -> Any {
        return InputCoordinate3D(
            latitude: serialized["latitude"] as! Double,
            longitude: serialized["longitude"] as! Double,
            altitudeMeters: serialized["altitudeMeters"] as! Double)
    }
}

public struct InputCoordinate3DPath : InputParameter {
    public let path : [InputCoordinate3D]
    
    public init(path : [InputCoordinate3D]) {
        self.path = path
    }
    
    public func toSerializable() -> AnyObject {
        var list = [AnyObject]()
        
        for hop in path {
            list.append(hop.toSerializable())
        }
        
        return list
    }
    
    public static func fromSerializable(serialized: AnyObject) -> Any {
        var list = [InputCoordinate3D]()
        
        for hop in serialized as! [AnyObject] {
            list.append(InputCoordinate3D.fromSerializable(hop) as! InputCoordinate3D)
        }
        
        return InputCoordinate3DPath(path: list)
    }
}


