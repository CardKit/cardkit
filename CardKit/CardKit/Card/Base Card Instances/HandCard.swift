//
//  HandCard.swift
//  CardKit
//
//  Created by Justin Weisz on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy

//MARK: HandBranchSpec

public struct HandBranchSpec {
    /// Specifies the conditions upon which to branch to the target Hand.
    public var spec: HandSatisfactionSpec
    
    /// The identifier of the Hand to which to branch.
    public var target: HandIdentifier
    
    init(branchingTo target: HandIdentifier, withSpec spec: HandSatisfactionSpec) {
        self.spec = spec
        self.target = target
    }
}

//MARK: JSONEncodable

extension HandBranchSpec: JSONEncodable {
    public func toJSON() -> JSON {
        return .Dictionary([
            "spec": self.spec.toJSON(),
            "target": self.target.toJSON()
            ])
    }
}

//MARK: JSONDecodable

extension HandBranchSpec: JSONDecodable {
    public init(json: JSON) throws {
        self.spec = try json.decode("spec", type: HandSatisfactionSpec.self)
        self.target = try json.decode("target", type: HandIdentifier.self)
    }
}


//MARK:- HandRepeatSpec

public struct HandRepeatSpec {
    /// Repeat the hand this many times
    public var count: Int
    
    init(count: Int) {
        self.count = count
    }
}

//MARK: JSONEncodable

extension HandRepeatSpec: JSONEncodable {
    public func toJSON() -> JSON {
        return .Int(self.count)
    }
}

//MARK: JSONDecodable

extension HandRepeatSpec: JSONDecodable {
    public init(json: JSON) throws {
        self.count = try json.int()
    }
}


//MARK:- HandSatisfactionSpec

public indirect enum HandSatisfactionSpec {
    case End(ActionCard)
    case All([HandSatisfactionSpec])
    case Any([HandSatisfactionSpec])
    case LogicalAnd(HandSatisfactionSpec, HandSatisfactionSpec)
    case LogicalOr(HandSatisfactionSpec, HandSatisfactionSpec)
    case LogicalXor(HandSatisfactionSpec, HandSatisfactionSpec)
    case LogicalNot(HandSatisfactionSpec)
}

//MARK: JSONEncodable

extension HandSatisfactionSpec: JSONEncodable {
    public func toJSON() -> JSON {
        switch self {
        case .End(let action):
            return .Dictionary(["logic": "End", "action": action.toJSON()])
        case .All(let specs):
            return .Dictionary(["logic": "All", "specs": specs.toJSON()])
        case .Any(let specs):
            return .Dictionary(["logic": "Any", "specs": specs.toJSON()])
        case .LogicalAnd(let lhs, let rhs):
            return .Dictionary(["logic": "LogicalAnd", "lhs": lhs.toJSON(), "rhs": rhs.toJSON()])
        case .LogicalOr(let lhs, let rhs):
            return .Dictionary(["logic": "LogicalOr", "lhs": lhs.toJSON(), "rhs": rhs.toJSON()])
        case .LogicalXor(let lhs, let rhs):
            return .Dictionary(["logic": "LogicalXor", "lhs": lhs.toJSON(), "rhs": rhs.toJSON()])
        case .LogicalNot(let spec):
            return .Dictionary(["logic": "LogicalNot", "spec": spec.toJSON()])
        }
    }
}

//MARK: JSONDecodable

extension HandSatisfactionSpec: JSONDecodable {
    public init(json: JSON) throws {
        guard let logicJson = json["logic"] else {
            throw JSON.Error.ValueNotConvertible(value: json, to: HandSatisfactionSpec.self)
        }
        
        let logic = try logicJson.string()
        
        switch logic {
        case "End":
            let action = try json.decode("action", type: ActionCard.self)
            self = .End(action)
        case "All":
            let specs = try json.arrayOf("specs", type: HandSatisfactionSpec.self)
            self = .All(specs)
        case "Any":
            let specs = try json.arrayOf("specs", type: HandSatisfactionSpec.self)
            self = .Any(specs)
        case "LogicalAnd":
            let lhs = try json.decode("lhs", type: HandSatisfactionSpec.self)
            let rhs = try json.decode("rhs", type: HandSatisfactionSpec.self)
            self = .LogicalAnd(lhs, rhs)
        case "LogicalOr":
            let lhs = try json.decode("lhs", type: HandSatisfactionSpec.self)
            let rhs = try json.decode("rhs", type: HandSatisfactionSpec.self)
            self = .LogicalOr(lhs, rhs)
        case "LogicalXor":
            let lhs = try json.decode("lhs", type: HandSatisfactionSpec.self)
            let rhs = try json.decode("rhs", type: HandSatisfactionSpec.self)
            self = .LogicalXor(lhs, rhs)
        case "LogicalNot":
            let spec = try json.decode("spec", type: HandSatisfactionSpec.self)
            self = .LogicalNot(spec)
        default:
            throw JSON.Error.ValueNotConvertible(value: json, to: HandSatisfactionSpec.self)
        }
    }
}


//MARK:- HandLogic

public enum HandLogicAction {
    /// Branch to the specified hand with the given branching specification.
    case Branch(HandBranchSpec)
    
    /// Repeat executing the hand the specified number of times.
    case Repeat(HandRepeatSpec)
    
    /// Conclude execution of this hand based on the given satisfaction specification.
    case SatisfactionLogic(HandSatisfactionSpec)
}

//MARK: JSONEncodable

extension HandLogicAction: JSONEncodable {
    public func toJSON() -> JSON {
        switch self {
        case .Branch(let spec):
            return .Dictionary([
                "action": "Branch",
                "spec": spec.toJSON()])
        case .Repeat(let spec):
            return .Dictionary([
                "action": "Repeat",
                "spec": spec.toJSON()])
        case .SatisfactionLogic(let spec):
            return .Dictionary([
                "action": "SatisfactionLogic",
                "spec": spec.toJSON()])
        }
    }
}

//MARK: JSONDecodable

extension HandLogicAction: JSONDecodable {
    public init(json: JSON) throws {
        guard let actionJson = json["action"] else {
            throw JSON.Error.ValueNotConvertible(value: json, to: HandLogicAction.self)
        }
        
        let action = try actionJson.string()
        
        switch action {
        case "Branch":
            let spec = try json.decode("spec", type: HandBranchSpec.self)
            self = .Branch(spec)
        case "Repeat":
            let spec = try json.decode("spec", type: HandRepeatSpec.self)
            self = .Repeat(spec)
        case "SatisfactionLogic":
            let spec = try json.decode("spec", type: HandSatisfactionSpec.self)
            self = .SatisfactionLogic(spec)
        default:
            throw JSON.Error.ValueNotConvertible(value: json, to: HandLogicAction.self)
        }
    }
}


//MARK:- HandCard

public struct HandCard: Card {
    public let descriptor: HandCardDescriptor
    
    // Card protocol
    public var identifier: CardIdentifier { return descriptor.identifier }
    public var description: String { return descriptor.description }
    public var assetCatalog: CardAssetCatalog { return descriptor.assetCatalog }
    public var cardType: CardType { return descriptor.cardType }
    
    // specifies what this hand card will do
    public var handLogic: HandLogicAction? = nil
    
    init(with descriptor: HandCardDescriptor) {
        self.descriptor = descriptor
    }
}

//MARK: JSONDecodable

extension HandCard: JSONDecodable {
    public init(json: JSON) throws {
        self.descriptor = try json.decode("descriptor", type: HandCardDescriptor.self)
        
        if let _ = json["handLogic"] {
            self.handLogic = try json.decode("handLogic", type: HandLogicAction.self)
        } else {
            self.handLogic = nil
        }
    }
}

//MARK: JSONEncodable

extension HandCard: JSONEncodable {
    public func toJSON() -> JSON {
        if let handLogic = self.handLogic {
            return .Dictionary([
                "descriptor": self.descriptor.toJSON(),
                "handLogic": handLogic.toJSON()
                ])
        } else {
            return .Dictionary([
                "descriptor": self.descriptor.toJSON()
                ])
        }
    }
}
