//
//  TokenCard.swift
//  CardKit
//
//  Created by Justin Weisz on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

public class TokenCard: Card, Codable {
    public let descriptor: TokenCardDescriptor
    
    // Card protocol
    public fileprivate (set) var identifier: CardIdentifier = CardIdentifier()
    public var cardType: CardType { return descriptor.cardType }
    public var description: String { return descriptor.description }
    public var assetCatalog: CardAssetCatalog { return descriptor.assetCatalog }
    
    init(with descriptor: TokenCardDescriptor) {
        self.descriptor = descriptor
    }
}

// MARK: Equatable

extension TokenCard: Equatable {
    static public func == (lhs: TokenCard, rhs: TokenCard) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

// MARK: Hashable

extension TokenCard: Hashable {
    public var hashValue: Int {
        return self.identifier.hashValue
    }
}
