//
//  InputCardDescriptor.swift
//  CardKit
//
//  Created by Justin Weisz on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy

public struct InputCardDescriptor: CardDescriptor, ProvidesInput {
    public let identifier: CardIdentifier
    public let description: String
    public let assetCatalog: CardAssetCatalog
    
    public let parameter: InputParameter
    
    public var cardType: CardType {
        get {
            return .Input
        }
    }
    
    public init(name: String, subpath: String, description: String, assetCatalog: CardAssetCatalog, version: Int = 0) {
        let p = (subpath == "") ? "Input" : "Input/\(subpath)"
        self.identifier = CardIdentifier(path: p, name: name, version: version)
        self.description = description
        self.assetCatalog = assetCatalog
    }
}

//MARK: JSONEncodable

extension InputCardDescriptor: JSONEncodable {
    public func toJSON() -> JSON {
        return .Dictionary([
            "identifier": identifier.toJSON(),
            "description": description.toJSON(),
            "assetCatalog": assetCatalog.toJSON(),
            "parameter": parameter.toJSON()
            ])
    }
}

//MARK: JSONDecodable

extension InputCardDescriptor: JSONDecodable {
    public init(json: JSON) throws {
        self.identifier = try json.decode("identifier", type: CardIdentifier.self)
        self.description = try json.string("description")
        self.assetCatalog = try json.decode("assetCatalog", type: CardAssetCatalog.self)
        self.parameter = try json.decode("parameter", type: InputParameter.self)
    }
}
