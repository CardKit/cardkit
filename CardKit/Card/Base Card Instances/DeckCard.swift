//
//  DeckCard.swift
//  CardKit
//
//  Created by Justin Weisz on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy

public class DeckCard: Card, JSONEncodable, JSONDecodable {
    public let descriptor: DeckCardDescriptor
    
    // Card protocol
    public fileprivate (set) var identifier: CardIdentifier = CardIdentifier()
    public var cardType: CardType { return descriptor.cardType }
    public var description: String { return descriptor.description }
    public var assetCatalog: CardAssetCatalog { return descriptor.assetCatalog }
    
    init(with descriptor: DeckCardDescriptor) {
        self.descriptor = descriptor
    }
    
    // MARK: JSONEncodable & JSONDecodable
    
    public required init(json: JSON) throws {
        self.identifier = try json.decode(at: "identifier", type: CardIdentifier.self)
        self.descriptor = try json.decode(at: "descriptor", type: DeckCardDescriptor.self)
    }
    
    public func toJSON() -> JSON {
        return .dictionary([
            "identifier": self.identifier.toJSON(),
            "descriptor": self.descriptor.toJSON()
            ])
    }
}

// MARK: Equatable

extension DeckCard: Equatable {
    static public func == (lhs: DeckCard, rhs: DeckCard) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

// MARK: Hashable

extension DeckCard: Hashable {
    public var hashValue: Int {
        return self.identifier.hashValue
    }
}
