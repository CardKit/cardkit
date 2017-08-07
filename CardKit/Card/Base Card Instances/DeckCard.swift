//
//  DeckCard.swift
//  CardKit
//
//  Created by Justin Weisz on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

public class DeckCard: Card, Codable {
    public let descriptor: DeckCardDescriptor
    
    // Card protocol
    public fileprivate (set) var identifier: CardIdentifier = CardIdentifier()
    public var cardType: CardType { return descriptor.cardType }
    public var description: String { return descriptor.description }
    public var assetCatalog: CardAssetCatalog { return descriptor.assetCatalog }
    
    public init(with descriptor: DeckCardDescriptor) {
        self.descriptor = descriptor
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
