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
    public var children: Set<CardIdentifier> = Set()
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
                "children": Array(self.children).toJSON()
                ])
        } else {
            return .Dictionary([
                "identifier": self.identifier.toJSON(),
                "descriptor": self.descriptor.toJSON(),
                "children": Array(self.children).toJSON()
                ])
        }
    }
    
    public func addChild(identifier: CardIdentifier) {
        self.children.insert(identifier)
    }
    
    public func addChildren<T where T: CollectionType, T.Generator.Element == CardIdentifier>(identifiers: T) {
        for identifier in identifiers {
            self.children.insert(identifier)
        }
    }
    
    public func removeChild(identifier: CardIdentifier) {
        self.children.remove(identifier)
    }
    
    public func removeChildren<T where T: CollectionType, T.Generator.Element == CardIdentifier>(identifiers: T) {
        for identifier in identifiers {
            self.children.remove(identifier)
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
    public var children: Set<CardIdentifier> = Set()
    
    public override init(with descriptor: HandCardDescriptor) {
        super.init(with: descriptor)
    }
    
    public required init(json: JSON) throws {
        try super.init(json: json)
    }
    
    public override func toJSON() -> JSON {
        return .Dictionary([
            "identifier": self.identifier.toJSON(),
            "descriptor": self.descriptor.toJSON(),
            "children": Array(self.children).toJSON()
            ])
    }
    
    public func addChild(identifier: CardIdentifier) {
        self.children.insert(identifier)
    }
    
    public func addChildren<T where T: CollectionType, T.Generator.Element == CardIdentifier>(identifiers: T) {
        for identifier in identifiers {
            self.children.insert(identifier)
        }
    }
    
    public func removeChild(identifier: CardIdentifier) {
        self.children.remove(identifier)
    }
    
    public func removeChildren<T where T: CollectionType, T.Generator.Element == CardIdentifier>(identifiers: T) {
        for identifier in identifiers {
            self.children.remove(identifier)
        }
    }
}
