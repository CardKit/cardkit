import Foundation

public protocol CardDesc : JsonSerializable {
    var id          : CardId { get }
    var icon        : String { get }
    var description : String { get }
    var renderer    : CardRenderer { get }
}

internal protocol SatisfiableCardDesc : CardDesc {
    var ends : Bool { get }
}

internal protocol AcceptsInputsCardDesc : CardDesc {
    var mandatoryInputs : [String: InputCardDesc] { get }
    var optionalInputs  : [String: InputCardDesc] { get }
}

internal protocol AcceptsTokensCardDesc : CardDesc {
    var tokens : [String: TokenCardDesc] { get }
}

public final class InputCardDesc : CardDesc {
    private static var index = [CardId: InputCardDesc]()
    
    public let id           : CardId
    public let parameter    : InputParameter.Type
    public let icon         : String
    public let description  : String
    public let renderer     : CardRenderer
    
    public init(path : CardPath, name : String, parameter: InputParameter.Type, icon : String = "", description : String = "", renderer : InputCardRenderer = InputCardRenderer.defaultInstance) {
        id = CardId(path: path, name: name)
        self.parameter      = parameter
        self.icon           = icon
        self.description    = description
        self.renderer       = renderer
        
        InputCardDesc.index[id] = self
    }
    
    public final func toSerializable() -> AnyObject {
        var dict = [String: AnyObject]()
        dict["id"] = id.toSerializable()
        
//        if !parameterTypes.isEmpty {
//            dict["parameterTypes"] = serializeBestEffortArray(parameterTypes)
//        }
        
        return dict
    }
    
    public static func lookup(id: CardId) -> InputCardDesc {
        return index[id]!
    }
}

public final class TokenCardDesc : CardDesc {
    private static var index = [CardId: TokenCardDesc]()
    
    public let id           : CardId
    public let consumed     : Bool
    public let icon         : String
    public let description  : String
    public let renderer     : CardRenderer
    
    public init(path: CardPath, name: String, consumed : Bool, icon : String = "", description : String = "", renderer : TokenCardRenderer = TokenCardRenderer.defaultInstance) {
        id                  = CardId(path: path, name: name)
        self.consumed       = consumed
        self.icon           = icon
        self.description    = description
        self.renderer       = renderer
        
        TokenCardDesc.index[id] = self
    }
    
    public final func toSerializable() -> AnyObject {
        var dict = [String: AnyObject]()
        dict["id"] = id.toSerializable()
        return dict
    }
    
    public static func lookup(id: CardId) -> TokenCardDesc {
        return index[id]!
    }
}


public final class ActionCardDesc : CardDesc, SatisfiableCardDesc, AcceptsInputsCardDesc, AcceptsTokensCardDesc {
    private static var index = [CardId: ActionCardDesc]()
    
    public let id               : CardId
    public let ends             : Bool
    public let mandatoryInputs  : [String: InputCardDesc]
    public let optionalInputs   : [String: InputCardDesc]
    public let tokens           : [String: TokenCardDesc]
    public let icon             : String
    public let description      : String
    public let endDescription   : String
    public let yieldDescription : String
    public let renderer         : CardRenderer
    public let factory          : ActionFactory
    
    public init(
            path                : CardPath,
            name                : String,
            ends                : Bool                      = false,
            mandatoryInputs     : [String: InputCardDesc]   = [String: InputCardDesc](),
            optionalInputs      : [String: InputCardDesc]   = [String: InputCardDesc](),
            tokens              : [String: TokenCardDesc]   = [String: TokenCardDesc](),
            icon                : String                    = "",
            description         : String                    = "",
            endDescription      : String                    = "",
            yieldDescription    : String                    = "",
            renderer            : ActionCardRenderer        = ActionCardRenderer.defaultInstance,
            factory             : ActionFactory?            = nil) {
                
        id                      = CardId(path: path, name: name)
        self.ends               = ends
        self.mandatoryInputs    = mandatoryInputs
        self.optionalInputs     = optionalInputs
        self.tokens             = tokens
        self.icon               = icon
        self.description        = description
        self.endDescription     = endDescription
        self.yieldDescription   = yieldDescription
        self.renderer           = renderer
        self.factory            = factory != nil ? factory! : { (inputs, tokens) -> ActionImpl in
            return SimpleActionImpl(
                setup:      { print(" setup: "     + name) },
                execute:    { print("   execute: "   + name) },
                interrupt:  { print("     interrupt: " + name) },
                teardown:   { print("       teardown: "  + name) })
        }
        
        ActionCardDesc.index[id] = self
    }
    
    public final func toSerializable() -> AnyObject {
        var dict = [String: AnyObject]()
        dict["id"] = id.toSerializable()
        dict["ends"] = ends
        
//        if !mandatoryInputs.isEmpty {
//            dict["mandatoryInputs"] = serializeBestEffortArray(mandatoryInputs)
//        }
//        
//        if !optionalInputs.isEmpty {
//            dict["optionalInputs"] = serializeBestEffortArray(optionalInputs)
////        }
//        
//        if !consumableTokens.isEmpty {
//            dict["consumableTokens"] = serializeBestEffortArray(consumableTokens)
//        }
//        
//        if !sharableTokens.isEmpty {
//            dict["sharableTokens"] = serializeBestEffortArray(sharableTokens)
//        }
        
        return dict
    }
    
    public static func lookup(id: CardId) -> ActionCardDesc {
        return index[id]!
    }
}

public final class HandCardDesc : CardDesc {
    private static var index = [CardId: HandCardDesc]()
    
    public let id           : CardId
    public let icon         : String
    public let description  : String
    public let renderer     : CardRenderer
    
    init(path: CardPath, name: String, icon : String = "", description : String = "", renderer : HandCardRenderer = HandCardRenderer.defaultInstance) {
        id                  = CardId(path: path, name: name)
        self.icon           = icon
        self.description    = description
        self.renderer       = renderer
        
        HandCardDesc.index[id] = self
    }
    
    public final func toSerializable() -> AnyObject {
        var dict = [String: AnyObject]()
        dict["id"] = id.toSerializable()
        return dict
    }
    
    public static func lookup(id: CardId) -> HandCardDesc {
        return index[id]!
    }
}

public final class DeckCardDesc : CardDesc {
    private static var index = [CardId: DeckCardDesc]()
    
    public let id           : CardId
    public let icon         : String
    public let description  : String
    public let renderer     : CardRenderer

    init(path: CardPath, name: String, icon : String = "", description : String = "", renderer : DeckCardRenderer = DeckCardRenderer.defaultInstance) {
        id                  = CardId(path: path, name: name)
        self.icon           = icon
        self.description    = description
        self.renderer       = renderer
        
        DeckCardDesc.index[id] = self
    }
    
    public final func toSerializable() -> AnyObject {
        var dict = [String: AnyObject]()
        dict["id"] = id.toSerializable()
        return dict
    }
    
    public static func lookup(id: CardId) -> DeckCardDesc {
        return index[id]!
    }
}


