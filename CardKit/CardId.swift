import Foundation

public struct CardId : JsonSerializable, Hashable, Equatable {
    public let path    : CardPath
    public let name    : String
    public let version : Int
    
    public init(path: CardPath, name: String, version: Int = 0) {
        self.path       = path
        self.name       = name
        self.version    = version
    }
    
    public func toSerializable() -> AnyObject {
        var dict = [String: AnyObject]()
        dict["name"]    = name
        dict["path"]    = path.toSerializable()
        dict["version"] = version
        return dict
    }
    
    public var hashValue: Int {
        get {
            let pathH       : Int = path.hashValue
            let nameH       : Int = name.hashValue
            let versionH    : Int = version.hashValue
            return pathH &+ (nameH &* 3) &+ (versionH &* 5)
        }
    }
}

public func ==(lhs: CardId, rhs: CardId) -> Bool {
    return lhs.name == rhs.name && lhs.path == rhs.path && lhs.version == rhs.version
}

public func !=(lhs: CardId, rhs: CardId) -> Bool {
    return !(lhs.name == rhs.name)
}
