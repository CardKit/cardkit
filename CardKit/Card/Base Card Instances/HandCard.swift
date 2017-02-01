//
//  HandCard.swift
//  CardKit
//
//  Created by Justin Weisz on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy

// MARK: HandCard

public class HandCard: Card {
    public let descriptor: HandCardDescriptor
    
    // Card protocol
    public fileprivate (set) var identifier: CardIdentifier = CardIdentifier()
    public var cardType: CardType { return descriptor.cardType }
    public var description: String { return descriptor.description }
    public var assetCatalog: CardAssetCatalog { return descriptor.assetCatalog }
    
    fileprivate init(with descriptor: HandCardDescriptor) {
        self.descriptor = descriptor
    }
}

// MARK: Equatable

extension HandCard: Equatable {
    static public func == (lhs: HandCard, rhs: HandCard) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

// MARK: Hashable

extension HandCard: Hashable {
    public var hashValue: Int {
        return self.identifier.hashValue
    }
}


// MARK: - BranchHandCard

public class BranchHandCard: HandCard, JSONEncodable, JSONDecodable {
    public var cardTreeIdentifier: CardTreeIdentifier?
    public var targetHandIdentifier: HandIdentifier?
    
    public override init(with descriptor: HandCardDescriptor) {
        super.init(with: descriptor)
    }
    
    public required init(json: JSON) throws {
        let cardTreeIdentifierStr = try json.getString(at: "cardTreeIdentifier")
        if cardTreeIdentifierStr == "nil" {
            self.cardTreeIdentifier = nil
        } else {
            self.cardTreeIdentifier = try json.decode(at: "cardTreeIdentifier", type: CardTreeIdentifier.self)
        }
        
        let targetHandStr = try json.getString(at: "targetHandIdentifier")
        if targetHandStr == "nil" {
            self.targetHandIdentifier = nil
        } else {
            self.targetHandIdentifier = try json.decode(at: "targetHandIdentifier", type: HandIdentifier.self)
        }
        
        let descriptor = try json.decode(at: "descriptor", type: HandCardDescriptor.self)
        super.init(with: descriptor)
        
        // overwrite self.identifier because it was generated in super.init()
        self.identifier = try json.decode(at: "identifier", type: CardIdentifier.self)
    }
    
    public func toJSON() -> JSON {
        return .dictionary([
            "identifier": self.identifier.toJSON(),
            "descriptor": self.descriptor.toJSON(),
            "cardTreeIdentifier": self.cardTreeIdentifier?.toJSON() ?? .string("nil"),
            "targetHandIdentifier": self.targetHandIdentifier?.toJSON() ?? .string("nil")
            ])
    }
}


// MARK: - RepeatHandCard

public class RepeatHandCard: HandCard, JSONEncodable, JSONDecodable {
    public var repeatCount: Int = 0
    
    public override init(with descriptor: HandCardDescriptor) {
        super.init(with: descriptor)
    }
    
    public required init(json: JSON) throws {
        self.repeatCount = try json.getInt(at: "repeatCount")
        
        let descriptor = try json.decode(at: "descriptor", type: HandCardDescriptor.self)
        super.init(with: descriptor)
        
        // overwrite self.identifier because it was generated in super.init()
        self.identifier = try json.decode(at: "identifier", type: CardIdentifier.self)
    }
    
    public func toJSON() -> JSON {
        return .dictionary([
            "identifier": self.identifier.toJSON(),
            "descriptor": self.descriptor.toJSON(),
            "repeatCount": self.repeatCount.toJSON()
            ])
    }
}

// MARK: - EndRuleHandCard

public class EndRuleHandCard: HandCard, JSONEncodable, JSONDecodable {
    public var endRule: HandEndRule {
        switch self.descriptor.handCardType {
        case .endWhenAnySatisfied:
            return .endWhenAnySatisfied
        case .endWhenAllSatisfied:
            return .endWhenAllSatisfied
        default:
            return .indeterminate
        }
    }
    
    public override init(with descriptor: HandCardDescriptor) {
        super.init(with: descriptor)
    }
    
    public required init(json: JSON) throws {
        let descriptor = try json.decode(at: "descriptor", type: HandCardDescriptor.self)
        super.init(with: descriptor)
        
        // overwrite self.identifier because it was generated in super.init()
        self.identifier = try json.decode(at: "identifier", type: CardIdentifier.self)
    }
    
    public func toJSON() -> JSON {
        return .dictionary([
            "identifier": self.identifier.toJSON(),
            "descriptor": self.descriptor.toJSON()
            ])
    }
}

// MARK: - LogicHandCard

public class LogicHandCard: HandCard, JSONEncodable, JSONDecodable {
    public var operation: HandLogicOperation {
        switch self.descriptor.handCardType {
        case .booleanLogicAnd:
            return .booleanAnd
        case .booleanLogicOr:
            return .booleanOr
        case .booleanLogicNot:
            return .booleanNot
        default:
            return .indeterminate
        }
    }
    
    public override init(with descriptor: HandCardDescriptor) {
        super.init(with: descriptor)
    }
    
    public required init(json: JSON) throws {
        let descriptor = try json.decode(at: "descriptor", type: HandCardDescriptor.self)
        super.init(with: descriptor)
        
        // overwrite self.identifier because it was generated in super.init()
        self.identifier = try json.decode(at: "identifier", type: CardIdentifier.self)
    }
    
    public func toJSON() -> JSON {
        return .dictionary([
            "identifier": self.identifier.toJSON(),
            "descriptor": self.descriptor.toJSON()
            ])
    }
    
    func asCardTreeNode() -> CardTreeNode? {
        switch self.operation {
        case .booleanAnd, .booleanOr:
            return .binaryLogic(self, nil, nil)
        case .booleanNot:
            return .unaryLogic(self, nil)
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
