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

public struct HandCard: Card {
    public let descriptor: HandCardDescriptor
    
    // Card protocol
    public var identifier: CardIdentifier = CardIdentifier()
    public var cardType: CardType { return descriptor.cardType }
    public var description: String { return descriptor.description }
    public var assetCatalog: CardAssetCatalog { return descriptor.assetCatalog }
    
    // specifies what this hand card will do
    public var logic: LogicBinding? = nil
    
    init(with descriptor: HandCardDescriptor) {
        self.descriptor = descriptor
    }
}

//MARK: JSONDecodable

extension HandCard: JSONDecodable {
    public init(json: JSON) throws {
        self.identifier = try json.decode("identifier", type: CardIdentifier.self)
        self.descriptor = try json.decode("descriptor", type: HandCardDescriptor.self)
        
        if let _ = json["logic"] {
            self.logic = try json.decode("logic", type: LogicBinding.self)
        } else {
            self.logic = nil
        }
    }
}

//MARK: JSONEncodable

extension HandCard: JSONEncodable {
    public func toJSON() -> JSON {
        if let logic = self.logic {
            return .Dictionary([
                "identifier": self.identifier.toJSON(),
                "descriptor": self.descriptor.toJSON(),
                "logic": logic.toJSON()
                ])
        } else {
            return .Dictionary([
                "identifier": self.identifier.toJSON(),
                "descriptor": self.descriptor.toJSON()
                ])
        }
    }
}
