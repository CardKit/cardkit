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
    
    public let cardType: CardType = .Hand
    
    public init(name: String, subpath: String?, description: String, assetCatalog: CardAssetCatalog, version: Int = 0) {
        let p = "Hand/\(subpath)" ?? "Hand"
        self.identifier = CardIdentifier(name: name, path: p, version: version)
        self.description = description
        self.assetCatalog = assetCatalog
    }
}

//MARK: Equatable

extension HandCardDescriptor: Equatable {}

public func == (lhs: HandCardDescriptor, rhs: HandCardDescriptor) -> Bool {
    var equal = true
    equal = equal && lhs.identifier == rhs.identifier
    // TODO: need to test other fields here?
    return equal
}

//MARK: Hashable

extension HandCardDescriptor: Hashable {
    public var hashValue: Int {
        return self.identifier.hashValue
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
