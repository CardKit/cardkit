//
//  HandCard.swift
//  CardKit
//
//  Created by Justin Weisz on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy

public struct HandCardDescriptor: CardDescriptor {
    public let identifier: CardIdentifier
    public let description: String
    public let assetCatalog: CardAssetCatalog
    
    public var cardType: CardType {
        get {
            return .Hand
        }
    }
    
    public init(name: String, subpath: String, description: String, assetCatalog: CardAssetCatalog, version: Int = 0) {
        let p = (subpath == "") ? "Hand" : "Hand/\(subpath)"
        self.identifier = CardIdentifier(path: p, name: name, version: version)
        self.description = description
        self.assetCatalog = assetCatalog
    }
}

//MARK: JSONEncodable

extension HandCardDescriptor: JSONEncodable {
    public func toJSON() -> JSON {
        return .Dictionary([
            "identifier": identifier.toJSON(),
            "description": description.toJSON(),
            "assetCatalog": assetCatalog.toJSON()
            ])
    }
}

//MARK: JSONDecodable

extension HandCardDescriptor: JSONDecodable {
    public init(json: JSON) throws {
        self.identifier = try json.decode("identifier", type: CardIdentifier.self)
        self.description = try json.string("description")
        self.assetCatalog = try json.decode("assetCatalog", type: CardAssetCatalog.self)
    }
}
