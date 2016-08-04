//
//  Logic.swift
//  CardKit
//
//  Created by Justin Weisz on 8/3/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy

//MARK: LogicType

public enum LogicType: String {
    /// Branch to another hand.
    case Branch
    
    /// Repeat executing the hand.
    case Repeat
    
    /// Conclude execution of this hand based on a satisfaction specification.
    case Logic
}

//MARK: CustomStringConvertable

extension LogicType: CustomStringConvertible {
    public var description: String {
        return "\(self)"
    }
}

//MARK: JSONEncodable

extension LogicType: JSONEncodable {
    public func toJSON() -> JSON {
        switch self {
        case .Branch:
            return .String("Branch")
        case .Repeat:
            return .String("Repeat")
        case .Logic:
            return .String("Logic")
        }
    }
}

//MARK: JSONDecodable

extension LogicType: JSONDecodable {
    public init(json: JSON) throws {
        let type = try json.string()
        guard let typeEnum = LogicType(rawValue: type) else {
            throw JSON.Error.ValueNotConvertible(value: json, to: LogicType.self)
        }
        self = typeEnum
    }
}


//MARK:- LogicBinding

public enum LogicBinding {
    /// Branch to the specified hand with the given branching specification.
    case Branch(HandBranchSpec)
    
    /// Repeat executing the hand the specified number of times.
    case Repeat(HandRepeatSpec)
    
    /// Conclude execution of this hand based on the given satisfaction specification.
    case Logic(HandSatisfactionSpec)
}

//MARK: CustomStringConvertable

extension LogicBinding: CustomStringConvertible {
    public var description: String {
        get {
            switch self {
            case .Branch(let spec):
                return "Branch [\(spec)]"
            case .Repeat(let spec):
                return "Repeat [\(spec)]"
            case .Logic(let spec):
                return "Logic [\(spec)]"
            }
        }
    }
}

//MARK: JSONEncodable

extension LogicBinding: JSONEncodable {
    public func toJSON() -> JSON {
        switch self {
        case .Branch(let spec):
            return .Dictionary([
                "type": "Branch",
                "spec": spec.toJSON()])
        case .Repeat(let spec):
            return .Dictionary([
                "type": "Repeat",
                "spec": spec.toJSON()])
        case .Logic(let spec):
            return .Dictionary([
                "type": "Logic",
                "spec": spec.toJSON()])
        }
    }
}

//MARK: JSONDecodable

extension LogicBinding: JSONDecodable {
    public init(json: JSON) throws {
        let type = try json.string("type")
        guard let typeEnum = LogicType(rawValue: type) else {
            throw JSON.Error.ValueNotConvertible(value: json, to: InputBinding.self)
        }
        
        switch typeEnum {
        case .Branch:
            let spec = try json.decode("spec", type: HandBranchSpec.self)
            self = .Branch(spec)
        case .Repeat:
            let spec = try json.decode("spec", type: HandRepeatSpec.self)
            self = .Repeat(spec)
        case .Logic:
            let spec = try json.decode("spec", type: HandSatisfactionSpec.self)
            self = .Logic(spec)
        }
    }
}


//MARK:- HandBranchSpec

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

//MARK: CustomStringConvertible

extension HandBranchSpec: CustomStringConvertible {
    public var description: String {
        return "<Branch to \(target) with condition [\(spec)]>"
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

//MARK: CustomStringConvertible

extension HandRepeatSpec: CustomStringConvertible {
    public var description: String {
        return "<Repeat hand \(count) times>"
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
    case Card(ActionCard)
    case All([HandSatisfactionSpec])
    case Any([HandSatisfactionSpec])
    case LogicalAnd(HandSatisfactionSpec, HandSatisfactionSpec)
    case LogicalOr(HandSatisfactionSpec, HandSatisfactionSpec)
    case LogicalXor(HandSatisfactionSpec, HandSatisfactionSpec)
    case LogicalNot(HandSatisfactionSpec)
}


//MARK: CustomStringConvertible

extension HandSatisfactionSpec: CustomStringConvertible {
    public var description: String {
        switch self {
        case .Card(let card):
            return "<ActionCard \(card.identifier)>"
        case .All(let specs):
            return "<Satisfy ALL: [\(specs)]>"
        case .Any(let specs):
            return "<Satisfy ANY: [\(specs)]>"
        case .LogicalAnd(let lhs, let rhs):
            return "<Satisfy AND: lhs: [\(lhs)], rhs: [\(rhs)]>"
        case .LogicalOr(let lhs, let rhs):
            return "<Satisfy OR: lhs: [\(lhs)], rhs: [\(rhs)]>"
        case .LogicalXor(let lhs, let rhs):
            return "<Satisfy XOR: lhs: [\(lhs)], rhs: [\(rhs)]>"
        case .LogicalNot(let spec):
            return "<Satisfy NOT: [\(spec)]>"
        }
    }
}

//MARK: JSONEncodable

extension HandSatisfactionSpec: JSONEncodable {
    public func toJSON() -> JSON {
        switch self {
        case .Card(let card):
            return .Dictionary(["logic": "Card", "card": card.toJSON()])
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
        case "Card":
            let card = try json.decode("card", type: ActionCard.self)
            self = .Card(card)
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
