//
//  HandCard.swift
//  CardKit
//
//  Created by Justin Weisz on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy

//MARK: HandCard

public class HandCard: Card {
    public let descriptor: HandCardDescriptor
    
    // Card protocol
    public var identifier: CardIdentifier = CardIdentifier()
    public var cardType: CardType { return descriptor.cardType }
    public var description: String { return descriptor.description }
    public var assetCatalog: CardAssetCatalog { return descriptor.assetCatalog }
    
    private init(with descriptor: HandCardDescriptor) {
        self.descriptor = descriptor
    }
}

//MARK: Equatable

extension HandCard: Equatable {}

public func == (lhs: HandCard, rhs: HandCard) -> Bool {
    return lhs.identifier == rhs.identifier
}

//MARK: Hashable

extension HandCard: Hashable {
    public var hashValue: Int {
        return self.identifier.hashValue
    }
}


//MARK:- BranchHandCard

public class BranchHandCard: HandCard, JSONEncodable, JSONDecodable {
    public var cardTreeIdentifier: CardTreeIdentifier? = nil
    public var targetHandIdentifier: HandIdentifier? = nil
    
    public override init(with descriptor: HandCardDescriptor) {
        super.init(with: descriptor)
    }
    
    public required init(json: JSON) throws {
        let cardTreeIdentifierStr = try json.string("cardTreeIdentifier")
        if cardTreeIdentifierStr == "nil" {
            self.cardTreeIdentifier = nil
        } else {
            self.cardTreeIdentifier = try json.decode("cardTreeIdentifier", type: CardTreeIdentifier.self)
        }
        
        let targetHandStr = try json.string("targetHandIdentifier")
        if targetHandStr == "nil" {
            self.targetHandIdentifier = nil
        } else {
            self.targetHandIdentifier = try json.decode("targetHandIdentifier", type: HandIdentifier.self)
        }
        
        let descriptor = try json.decode("descriptor", type: HandCardDescriptor.self)
        super.init(with: descriptor)
        
        // overwrite self.identifier because it was generated in super.init()
        self.identifier = try json.decode("identifier", type: CardIdentifier.self)
    }
    
    public func toJSON() -> JSON {
        return .Dictionary([
            "identifier": self.identifier.toJSON(),
            "descriptor": self.descriptor.toJSON(),
            "cardTreeIdentifier": self.cardTreeIdentifier?.toJSON() ?? .String("nil"),
            "targetHandIdentifier": self.targetHandIdentifier?.toJSON() ?? .String("nil")
            ])
    }
}


//MARK:- RepeatHandCard

public class RepeatHandCard: HandCard, JSONEncodable, JSONDecodable {
    public var repeatCount: Int = 0
    
    public override init(with descriptor: HandCardDescriptor) {
        super.init(with: descriptor)
    }
    
    public required init(json: JSON) throws {
        self.repeatCount = try json.int("repeatCount")
        
        let descriptor = try json.decode("descriptor", type: HandCardDescriptor.self)
        super.init(with: descriptor)
        
        // overwrite self.identifier because it was generated in super.init()
        self.identifier = try json.decode("identifier", type: CardIdentifier.self)
    }
    
    public func toJSON() -> JSON {
        return .Dictionary([
            "identifier": self.identifier.toJSON(),
            "descriptor": self.descriptor.toJSON(),
            "repeatCount": self.repeatCount.toJSON()
            ])
    }
}

//MARK:- EndRuleHandCard

public class EndRuleHandCard: HandCard, JSONEncodable, JSONDecodable {
    public var endRule: HandEndRule {
        switch self.descriptor.handCardType {
        case .EndWhenAnySatisfied:
            return .EndWhenAnySatisfied
        case .EndWhenAllSatisfied:
            return .EndWhenAllSatisfied
        default:
            return .Indeterminate
        }
    }
    
    public override init(with descriptor: HandCardDescriptor) {
        super.init(with: descriptor)
    }
    
    public required init(json: JSON) throws {
        let descriptor = try json.decode("descriptor", type: HandCardDescriptor.self)
        super.init(with: descriptor)
        
        // overwrite self.identifier because it was generated in super.init()
        self.identifier = try json.decode("identifier", type: CardIdentifier.self)
    }
    
    public func toJSON() -> JSON {
        return .Dictionary([
            "identifier": self.identifier.toJSON(),
            "descriptor": self.descriptor.toJSON()
            ])
    }
}

//MARK:- LogicHandCard

public class LogicHandCard: HandCard, JSONEncodable, JSONDecodable {
    public var operation: HandLogicOperation {
        switch self.descriptor.handCardType {
        case .BooleanLogicAnd:
            return .BooleanAnd
        case .BooleanLogicOr:
            return .BooleanOr
        case .BooleanLogicNot:
            return .BooleanNot
        default:
            return .Indeterminate
        }
    }
    
    public override init(with descriptor: HandCardDescriptor) {
        super.init(with: descriptor)
    }
    
    public required init(json: JSON) throws {
        let descriptor = try json.decode("descriptor", type: HandCardDescriptor.self)
        super.init(with: descriptor)
        
        // overwrite self.identifier because it was generated in super.init()
        self.identifier = try json.decode("identifier", type: CardIdentifier.self)
    }
    
    public func toJSON() -> JSON {
        return .Dictionary([
            "identifier": self.identifier.toJSON(),
            "descriptor": self.descriptor.toJSON()
            ])
    }
    
    func asCardTreeNode() -> CardTreeNode? {
        switch self.operation {
        case .BooleanAnd, .BooleanOr:
            return .BinaryLogic(self, nil, nil)
        case .BooleanNot:
            return .UnaryLogic(self, nil)
        default:
            return nil
        }
    }
    
    func asCardTree() -> CardTree? {
        let tree = CardTree()
        tree.root = self.asCardTreeNode()
        return tree
    }
}

/*public class LogicHandCard: HandCard, JSONEncodable, JSONDecodable {
    public var operation: HandLogicOperation {
        
    }
    
    public override init(with descriptor: HandCardDescriptor) {
        super.init(with: descriptor)
    }
    
    public required init(json: JSON) throws {
        self.identifier = try json.decode("identifier", type: CardIdentifier.self)
        self.operand = try UnaryLogicHandCard.decodeOperandFrom(json, named: "operand")
        
        let descriptor = try json.decode("descriptor", type: HandCardDescriptor.self)
        super.init(with: descriptor)
    }
    
    public func toJSON() -> JSON {
        if let operand = self.operand {
            return .Dictionary([
                "identifier": self.identifier.toJSON(),
                "descriptor": self.descriptor.toJSON(),
                "operand": operand.toJSON()
                ])
        } else {
            return .Dictionary([
                "identifier": self.identifier.toJSON(),
                "descriptor": self.descriptor.toJSON()
                ])
        }
    }
    
    /// Helper method for decoding HandCards that are operands of other HandCards
    private class func decodeOperandFrom(json: JSON, named operandName: String) throws -> SatisfiableCard? {
        let descriptor = try json.decode("descriptor", type: HandCardDescriptor.self)
        
        // need to figure out what card type we have as an operand to deserialize to the
        // correct class instance
        if let operandJSON = json[operandName] {
            let cardType = try operandJSON.decode("cardType", type: CardType.self)
            
            switch cardType {
            case .Action:
                return try json.decode("operand", type: ActionCard.self)
                
            case .Hand:
                switch descriptor.operation {
                case .BooleanLogicAnd:
                    return try json.decode("operand", type: BinaryLogicHandCard.self)
                case .BooleanLogicOr:
                    return try json.decode("operand", type: BinaryLogicHandCard.self)
                case .BooleanLogicNot:
                    return try json.decode("operand", type: UnaryLogicHandCard.self)
                default:
                    throw JSON.Error.ValueNotConvertible(value: json, to: UnaryLogicHandCard.self)
                }
                
            default:
                throw JSON.Error.ValueNotConvertible(value: json, to: UnaryLogicHandCard.self)
            }
        } else {
            return nil
        }
    }
}

extension UnaryLogicHandCard: SatisfiableCard {
    public var satisfactionLogic: SatisfactionLogic {
        if let operand = self.operand {
            // the unary logical operator is always NOT
            return .LogicalNot(.End(operand))
        } else {
            return .Indeterminate
        }
    }
}

extension UnaryLogicHandCard: HasChildren {
    public var children: [SatisfiableCard] {
        if let operand = self.operand {
            return [operand]
        } else {
            return []
        }
    }
}

//MARK: BinaryLogicHandCard

public class BinaryLogicHandCard: HandCard, JSONEncodable, JSONDecodable {
    public var lhs: SatisfiableCard? = nil
    public var rhs: SatisfiableCard? = nil
    
    public override init(with descriptor: HandCardDescriptor) {
        super.init(with: descriptor)
    }
    
    public required init(json: JSON) throws {
        self.identifier = try json.decode("identifier", type: CardIdentifier.self)
        self.lhs = try UnaryLogicHandCard.decodeOperandFrom(json, named: "lhs")
        self.rhs = try UnaryLogicHandCard.decodeOperandFrom(json, named: "rhs")
        
        let descriptor = try json.decode("descriptor", type: HandCardDescriptor.self)
        super.init(with: descriptor)
    }
    
    public func toJSON() -> JSON {
        switch (self.lhs, self.rhs) {
        case (.None, .None):
            return .Dictionary([
                "identifier": self.identifier.toJSON(),
                "descriptor": self.descriptor.toJSON()
                ])
        case (.Some(let lhs), .None):
            return .Dictionary([
                "identifier": self.identifier.toJSON(),
                "descriptor": self.descriptor.toJSON(),
                "lhs": lhs.toJSON()
                ])
        case (.None, .Some(let rhs)):
            return .Dictionary([
                "identifier": self.identifier.toJSON(),
                "descriptor": self.descriptor.toJSON(),
                "rhs": rhs.toJSON()
                ])
        case (.Some(let lhs), .Some(let rhs)):
            return .Dictionary([
                "identifier": self.identifier.toJSON(),
                "descriptor": self.descriptor.toJSON(),
                "lhs": lhs.toJSON(),
                "rhs": rhs.toJSON()
                ])
        }
    }
}

extension BinaryLogicHandCard: SatisfiableCard {
    public var satisfactionLogic: SatisfactionLogic {
        if let lhs = self.lhs, let rhs = self.rhs {
            if self.descriptor.operation == .BooleanLogicAnd {
                return .LogicalAnd(lhs.satisfactionLogic, rhs.satisfactionLogic)
            } else if self.descriptor.operation == .BooleanLogicOr {
                return .LogicalOr(lhs.satisfactionLogic, rhs.satisfactionLogic)
            }
        }
        
        return .Indeterminate
    }
}

extension BinaryLogicHandCard: HasChildren {
    public var children: [SatisfiableCard] {
        switch (self.lhs, self.rhs) {
        case (.None, .None):
            return []
        case (.Some(let lhs), .None):
            return [lhs]
        case (.None, .Some(let rhs)):
            return [rhs]
        case (.Some(let lhs), .Some(let rhs)):
            return [lhs, rhs]
        }
    }
}
*/
