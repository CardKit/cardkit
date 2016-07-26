public class CardPath : JsonSerializable, CustomStringConvertible, Hashable, Equatable  {
    private let parent  : CardPath?
    private let label    : String
    
    public static let Root :  CardPath = CardPath(label: "")
    
    private init (label: String) {
        parent = nil
        self.label = label
    }
    
    public init (parent: CardPath, label: String) {
        self.parent = parent
        self.label = label
    }
    
    public var hashValue: Int {
        get {
            return label.hashValue &+ (parent == nil ? 0 : parent!.hashValue)
        }
    }
    
    public var description : String {
        get {
            var string : String = label
            
            var element : CardPath? = parent
            while let uwElement = element  {
                string = uwElement.label + "/" + string
                element = uwElement.parent
            }
            
            return string
        }
    }
    
    public func toSerializable() -> AnyObject {
        var pathList = [String]()
        
        pathList.append(label)
        
        var element : CardPath? = parent
        while let uwElement = element  {
            if !uwElement.label.isEmpty {
                pathList.insert(uwElement.label, atIndex: 0)
            }
            
            element = uwElement.parent
        }
        
        return pathList
    }
}

public func == (left : CardPath, right : CardPath) -> Bool {
    if left.label != right.label {
        return false
    }
    
    if left.parent === right.parent {
        return true
    }
    
    if (left.parent == nil) != (right.parent == nil) {
        return false
    }
    
    return left.parent! == right.parent!
}

public func != (left : CardPath, right : CardPath) -> Bool {
    return !(left == right)
}
