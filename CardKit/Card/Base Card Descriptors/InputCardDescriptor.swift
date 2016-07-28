//
//  InputCardDescriptor.swift
//  CardKit
//
//  Created by Justin Weisz on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy

public struct InputCardDescriptor: CardDescriptor, ProducesYields {
    public let identifier: CardIdentifier
    public let description: String
    public let assetCatalog: CardAssetCatalog
    
    public var producesYields: Bool = true
    public var yieldDescription: String
    public var yields: [YieldType]
    
    public var cardType: CardType = .Input
    
    public init(name: String, subpath: String?, description: String, assetCatalog: CardAssetCatalog, provides inputs: [YieldType], version: Int = 0) {
        let p = "Input/\(subpath)" ?? "Input"
        self.identifier = CardIdentifier(name: name, path: p, version: version)
        self.description = description
        self.assetCatalog = assetCatalog
        self.yields = inputs
        self.yieldDescription = description
    }
}

//MARK: JSONEncodable

extension InputCardDescriptor: JSONEncodable {
    public func toJSON() -> JSON {
        return .Dictionary([
            "identifier": identifier.toJSON(),
            "description": description.toJSON(),
            "assetCatalog": assetCatalog.toJSON(),
            "producesYields": producesYields.toJSON(),
            "yieldDescription": description.toJSON(),
            "yields": yields.toJSON()
            ])
    }
}

//MARK: JSONDecodable

extension InputCardDescriptor: JSONDecodable {
    public init(json: JSON) throws {
        self.identifier = try json.decode("identifier", type: CardIdentifier.self)
        self.description = try json.string("description")
        self.assetCatalog = try json.decode("assetCatalog", type: CardAssetCatalog.self)
        self.yieldDescription = try json.string("yieldDescription")
        self.yields = try json.arrayOf("yields", type: YieldType.self)
    }
}
