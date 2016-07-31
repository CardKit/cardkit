//
//  InputCardDescriptor.swift
//  CardKit
//
//  Created by Justin Weisz on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy

public struct InputCardDescriptor: CardDescriptor, ProducesInput {
    public let identifier: CardIdentifier
    public let description: String
    public let assetCatalog: CardAssetCatalog
    
    public var inputType: YieldType
    public var inputDescription: String
    
    public let cardType: CardType = .Input
    
    public init(name: String, subpath: String?, description: String, assetCatalog: CardAssetCatalog, inputType: YieldType, inputDescription: String, version: Int = 0) {
        let p = "Input/\(subpath)" ?? "Input"
        self.identifier = CardIdentifier(name: name, path: p, version: version)
        self.description = description
        self.assetCatalog = assetCatalog
        self.inputType = inputType
        self.inputDescription = inputDescription
    }
}

//MARK: Equatable

extension InputCardDescriptor: Equatable {}

public func == (lhs: InputCardDescriptor, rhs: InputCardDescriptor) -> Bool {
    var equal = true
    equal = equal && lhs.identifier == rhs.identifier
    // TODO: need to test other fields here?
    return equal
}

//MARK: Hashable

extension InputCardDescriptor: Hashable {
    public var hashValue: Int {
        return self.identifier.hashValue
    }
}

//MARK: JSONEncodable

extension InputCardDescriptor: JSONEncodable {
    public func toJSON() -> JSON {
        return .Dictionary([
            "identifier": identifier.toJSON(),
            "description": description.toJSON(),
            "assetCatalog": assetCatalog.toJSON(),
            "inputType": inputType.toJSON(),
            "inputDescription": inputDescription.toJSON()
            ])
    }
}

//MARK: JSONDecodable

extension InputCardDescriptor: JSONDecodable {
    public init(json: JSON) throws {
        self.identifier = try json.decode("identifier", type: CardIdentifier.self)
        self.description = try json.string("description")
        self.assetCatalog = try json.decode("assetCatalog", type: CardAssetCatalog.self)
        self.inputType = try json.decode("inputType", type: YieldType.self)
        self.inputDescription = try json.string("inputDescription")
    }
}
