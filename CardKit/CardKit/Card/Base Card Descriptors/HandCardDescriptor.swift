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
    public let type: CardType = .Hand
    public let name: String
    public let path: CardPath
    public let version: Int
    public let description: String
    public let assetCatalog: CardAssetCatalog
    
    public let logicType: LogicType
    
    public init(name: String, subpath: String?, description: String, assetCatalog: CardAssetCatalog, logicType: LogicType, version: Int = 0) {
        self.name = name
        self.path = CardPath(withPath: "Hand/\(subpath)" ?? "Hand")
        self.version = version
        self.description = description
        self.assetCatalog = assetCatalog
        
        self.logicType = logicType
    }
}

//MARK: Equatable

extension HandCardDescriptor: Equatable {}

/// Card descriptors are equal when their names, paths, and versions are the same. All the other metadata should be the same when two descriptors have the same name, path, & version.
public func == (lhs: HandCardDescriptor, rhs: HandCardDescriptor) -> Bool {
    var equal = true
    equal = equal && lhs.name == rhs.name
    equal = equal && lhs.path == rhs.path
    equal = equal && lhs.version == rhs.version
    return equal
}

//MARK: Hashable

extension HandCardDescriptor: Hashable {
    public var hashValue: Int {
        return name.hashValue &+ (path.hashValue &* 3) &+ (version.hashValue &* 5)
    }
}

//MARK: JSONEncodable

extension HandCardDescriptor: JSONEncodable {
    public func toJSON() -> JSON {
        return .Dictionary([
            "type": type.toJSON(),
            "name": name.toJSON(),
            "path": path.toJSON(),
            "version": version.toJSON(),
            "description": description.toJSON(),
            "assetCatalog": assetCatalog.toJSON(),
            "logicType": logicType.toJSON()
            ])
    }
}

//MARK: JSONDecodable

extension HandCardDescriptor: JSONDecodable {
    public init(json: JSON) throws {
        self.name = try json.string("name")
        self.path = try json.decode("path", type: CardPath.self)
        self.version = try json.int("version")
        self.description = try json.string("description")
        self.assetCatalog = try json.decode("assetCatalog", type: CardAssetCatalog.self)
        self.logicType = try json.decode("logicType", type: LogicType.self)
    }
}
