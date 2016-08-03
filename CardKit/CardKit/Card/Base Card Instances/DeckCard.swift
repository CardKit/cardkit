//
//  DeckCard.swift
//  CardKit
//
//  Created by Justin Weisz on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy

public struct DeckCard: Card {
    public let descriptor: DeckCardDescriptor
    
    // Card protocol
    public var identifier: CardIdentifier = CardIdentifier()
    public var cardType: CardType { return descriptor.cardType }
    public var description: String { return descriptor.description }
    public var assetCatalog: CardAssetCatalog { return descriptor.assetCatalog }
    
    init(with descriptor: DeckCardDescriptor) {
        self.descriptor = descriptor
    }
}

//MARK: Equatable

extension DeckCard: Equatable {}

public func == (lhs: DeckCard, rhs: DeckCard) -> Bool {
    return lhs.identifier == rhs.identifier
}

//MARK: Hashable

extension DeckCard: Hashable {
    public var hashValue: Int {
        return self.identifier.hashValue
    }
}

//MARK: JSONDecodable

extension DeckCard: JSONDecodable {
    public init(json: JSON) throws {
        self.identifier = try json.decode("identifier", type: CardIdentifier.self)
        self.descriptor = try json.decode("descriptor", type: DeckCardDescriptor.self)
    }
}

//MARK: JSONEncodable

extension DeckCard: JSONEncodable {
    public func toJSON() -> JSON {
        return .Dictionary([
            "identifier": self.identifier.toJSON(),
            "descriptor": self.descriptor.toJSON()
            ])
    }
}
