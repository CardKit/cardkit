//
//  HandCard.swift
//  CardKit
//
//  Created by Justin Weisz on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy

public struct HandCard: Card {
    public let descriptor: HandCardDescriptor
    
    // Card protocol
    public var identifier: CardIdentifier { return descriptor.identifier }
    public var description: String { return descriptor.description }
    public var assetCatalog: CardAssetCatalog { return descriptor.assetCatalog }
    public var cardType: CardType { return descriptor.cardType }
    
    init(with descriptor: HandCardDescriptor) {
        self.descriptor = descriptor
    }
}

//MARK: JSONDecodable

extension HandCard: JSONDecodable {
    public init(json: JSON) throws {
        self.descriptor = try json.decode("descriptor", type: HandCardDescriptor.self)
    }
}

//MARK: JSONEncodable

extension HandCard: JSONEncodable {
    public func toJSON() -> JSON {
        return .Dictionary([
            "descriptor": self.descriptor.toJSON()
            ])
    }
}
