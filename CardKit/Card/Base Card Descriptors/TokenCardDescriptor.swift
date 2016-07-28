//
//  TokenCardDescriptor.swift
//  CardKit
//
//  Created by Justin Weisz on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy

public struct TokenCardDescriptor: CardDescriptor, Consumable {
    public let identifier: CardIdentifier
    public let description: String
    public let assetCatalog: CardAssetCatalog
    
    public let isConsumable: Bool
    
    public var cardType: CardType {
        get {
            return .Token
        }
    }
    
    public init(name: String, subpath: String?, description: String, assetCatalog: CardAssetCatalog, isConsumable: Bool, version: Int = 0) {
        let p = "Token/\(subpath)" ?? "Token"
        self.identifier = CardIdentifier(name: name, path: p, version: version)
        self.description = description
        self.assetCatalog = assetCatalog
        self.isConsumable = isConsumable
    }
}

//MARK: JSONEncodable

extension TokenCardDescriptor: JSONEncodable {
    public func toJSON() -> JSON {
        return .Dictionary([
            "identifier": identifier.toJSON(),
            "description": description.toJSON(),
            "assetCatalog": assetCatalog.toJSON(),
            "isConsumable": isConsumable.toJSON()
            ])
    }
}

//MARK: JSONDecodable

extension TokenCardDescriptor: JSONDecodable {
    public init(json: JSON) throws {
        self.identifier = try json.decode("identifier", type: CardIdentifier.self)
        self.description = try json.string("description")
        self.assetCatalog = try json.decode("assetCatalog", type: CardAssetCatalog.self)
        self.isConsumable = try json.bool("isConsumable")
    }
}
