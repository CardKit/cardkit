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
    public let type: CardType = .Input
    public let name: String
    public let path: CardPath
    public let version: Int
    public let description: String
    public let assetCatalog: CardAssetCatalog
    
    public let inputType: InputType
    public let inputDescription: String
    
    //swiftlint:disable:next function_parameter_count
    public init(name: String, subpath: String?, description: String, assetCatalog: CardAssetCatalog, inputType: InputType, inputDescription: String, version: Int = 0) {
        self.name = name
        self.path = CardPath(withPath: "Input/\(subpath)" ?? "Input")
        self.version = version
        self.description = description
        self.assetCatalog = assetCatalog
        
        self.inputType = inputType
        self.inputDescription = inputDescription
    }
}

//MARK: Equatable

extension InputCardDescriptor: Equatable {}

/// Card descriptors are equal when their names, paths, and versions are the same. All the other metadata should be the same when two descriptors have the same name, path, & version.
public func == (lhs: InputCardDescriptor, rhs: InputCardDescriptor) -> Bool {
    var equal = true
    equal = equal && lhs.name == rhs.name
    equal = equal && lhs.path == rhs.path
    equal = equal && lhs.version == rhs.version
    return equal
}

//MARK: Hashable

extension InputCardDescriptor: Hashable {
    public var hashValue: Int {
        return name.hashValue &+ (path.hashValue &* 3) &+ (version.hashValue &* 5)
    }
}

//MARK: JSONEncodable

extension InputCardDescriptor: JSONEncodable {
    public func toJSON() -> JSON {
        return .Dictionary([
            "type": type.toJSON(),
            "name": name.toJSON(),
            "path": path.toJSON(),
            "version": version.toJSON(),
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
        self.name = try json.string("name")
        self.path = try json.decode("path", type: CardPath.self)
        self.version = try json.int("version")
        self.description = try json.string("description")
        self.assetCatalog = try json.decode("assetCatalog", type: CardAssetCatalog.self)
        self.inputType = try json.decode("inputType", type: InputType.self)
        self.inputDescription = try json.string("inputDescription")
    }
}
