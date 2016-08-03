//
//  TokenCard.swift
//  CardKit
//
//  Created by Justin Weisz on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy

public struct TokenCard: Card {
    public let descriptor: TokenCardDescriptor
    
    // Card protocol
    public var identifier: CardIdentifier = CardIdentifier()
    public var cardType: CardType { return descriptor.cardType }
    public var description: String { return descriptor.description }
    public var assetCatalog: CardAssetCatalog { return descriptor.assetCatalog }
    
    init(with descriptor: TokenCardDescriptor) {
        self.descriptor = descriptor
    }
}

//MARK: Equatable

extension TokenCard: Equatable {}

public func == (lhs: TokenCard, rhs: TokenCard) -> Bool {
    return lhs.identifier == rhs.identifier
}

//MARK: Hashable

extension TokenCard: Hashable {
    public var hashValue: Int {
        return self.identifier.hashValue
    }
}

//MARK: JSONDecodable

extension TokenCard: JSONDecodable {
    public init(json: JSON) throws {
        self.identifier = try json.decode("identifier", type: CardIdentifier.self)
        self.descriptor = try json.decode("descriptor", type: TokenCardDescriptor.self)
    }
}

//MARK: JSONEncodable

extension TokenCard: JSONEncodable {
    public func toJSON() -> JSON {
        return .Dictionary([
            "identifier": self.identifier.toJSON(),
            "descriptor": self.descriptor.toJSON()
            ])
    }
}
