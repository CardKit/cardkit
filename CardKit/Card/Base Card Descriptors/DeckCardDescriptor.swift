//
//  DeckCardDescriptor.swift
//  CardKit
//
//  Created by Justin Weisz on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy

public struct DeckCardDescriptor: CardDescriptor {
    public let identifier: CardIdentifier
    public let description: String
    public let assetCatalog: CardAssetCatalog
    
    public var cardType: CardType {
        get {
            return .Deck
        }
    }
    
    public init(name: String, subpath: String?, description: String, assetCatalog: CardAssetCatalog, version: Int = 0) {
        let p = "Deck/\(subpath)" ?? "Deck"
        self.identifier = CardIdentifier(name: name, path: p, version: version)
        self.description = description
        self.assetCatalog = assetCatalog
    }
}

//MARK: JSONEncodable

extension DeckCardDescriptor: JSONEncodable {
    public func toJSON() -> JSON {
        return .Dictionary([
            "identifier": identifier.toJSON(),
            "description": description.toJSON(),
            "assetCatalog": assetCatalog.toJSON()
            ])
    }
}

//MARK: JSONDecodable

extension DeckCardDescriptor: JSONDecodable {
    public init(json: JSON) throws {
        self.identifier = try json.decode("identifier", type: CardIdentifier.self)
        self.description = try json.string("description")
        self.assetCatalog = try json.decode("assetCatalog", type: CardAssetCatalog.self)
    }
}
