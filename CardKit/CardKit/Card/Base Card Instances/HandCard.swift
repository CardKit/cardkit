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

public class HandCard: Card, JSONEncodable, JSONDecodable {
    public let descriptor: HandCardDescriptor
    
    // Card protocol
    public var identifier: CardIdentifier = CardIdentifier()
    public var cardType: CardType { return descriptor.cardType }
    public var description: String { return descriptor.description }
    public var assetCatalog: CardAssetCatalog { return descriptor.assetCatalog }
    
    init(with descriptor: HandCardDescriptor) {
        self.descriptor = descriptor
    }
    
    //MARK: JSONEncodable & JSONDecodable
    
    public required init(json: JSON) throws {
        self.identifier = try json.decode("identifier", type: CardIdentifier.self)
        self.descriptor = try json.decode("descriptor", type: HandCardDescriptor.self)
    }
    
    public func toJSON() -> JSON {
        return .Dictionary([
            "identifier": self.identifier.toJSON(),
            "descriptor": self.descriptor.toJSON()
            ])
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

//MARK: BranchHandCard

public class BranchHandCard: HandCard {
    public var children: [CardIdentifier] = []
    public var targetHand: HandIdentifier? = nil
    
    public override init(with descriptor: HandCardDescriptor) {
        super.init(with: descriptor)
    }
    
    public required init(json: JSON) throws {
        if let _ = json["tagetHand"] {
            self.targetHand = try json.decode("targetHand", type: HandIdentifier.self)
        } else {
            self.targetHand = nil
        }
        
        try super.init(json: json)
    }
    
    public override func toJSON() -> JSON {
        if let targetHand = self.targetHand {
            return .Dictionary([
                "identifier": self.identifier.toJSON(),
                "descriptor": self.descriptor.toJSON(),
                "targetHand": targetHand.toJSON(),
                "children": self.children.toJSON()
                ])
        } else {
            return .Dictionary([
                "identifier": self.identifier.toJSON(),
                "descriptor": self.descriptor.toJSON(),
                "children": self.children.toJSON()
                ])
        }
    }
}

//MARK: RepeatHandCard

public class RepeatHandCard: HandCard {
    public var repeatCount: Int = 0
    
    public override init(with descriptor: HandCardDescriptor) {
        super.init(with: descriptor)
    }
    
    public required init(json: JSON) throws {
        self.repeatCount = try json.int("repeatCount")
        try super.init(json: json)
    }
    
    public override func toJSON() -> JSON {
        return .Dictionary([
            "identifier": self.identifier.toJSON(),
            "descriptor": self.descriptor.toJSON(),
            "repeatCount": self.repeatCount.toJSON()
            ])
    }
}

//MARK: LogicHandCard

public class LogicHandCard: HandCard {
    public var children: [CardIdentifier] = []
    public let operation: BooleanOperation
    
    public init(with descriptor: HandCardDescriptor, operation: BooleanOperation) {
        self.operation = operation
        super.init(with: descriptor)
    }
    
    public required init(json: JSON) throws {
        self.operation = try json.decode("operation", type: BooleanOperation.self)
        try super.init(json: json)
    }
    
    public override func toJSON() -> JSON {
        return .Dictionary([
            "identifier": self.identifier.toJSON(),
            "descriptor": self.descriptor.toJSON(),
            "operation": self.operation.toJSON(),
            "children": self.children.toJSON()
            ])
    }
}
