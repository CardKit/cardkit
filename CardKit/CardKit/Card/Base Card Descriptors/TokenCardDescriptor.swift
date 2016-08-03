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
    public let type: CardType = .Token
    public let name: String
    public let path: CardPath
    public let version: Int
    public let assetCatalog: CardAssetCatalog
    
    public let isConsumed: Bool
    
    public init(name: String, subpath: String?, isConsumed: Bool, assetCatalog: CardAssetCatalog, version: Int = 0) {
        self.name = name
        self.path = CardPath(withPath: "Token/\(subpath)" ?? "Token")
        self.version = version
        self.assetCatalog = assetCatalog
        
        self.isConsumed = isConsumed
    }
}

//MARK: Equatable

extension TokenCardDescriptor: Equatable {}

/// Card descriptors are equal when their names, paths, and versions are the same. All the other metadata should be the same when two descriptors have the same name, path, & version.
public func == (lhs: TokenCardDescriptor, rhs: TokenCardDescriptor) -> Bool {
    var equal = true
    equal = equal && lhs.name == rhs.name
    equal = equal && lhs.path == rhs.path
    equal = equal && lhs.version == rhs.version
    return equal
}

//MARK: Hashable

extension TokenCardDescriptor: Hashable {
    public var hashValue: Int {
        return name.hashValue &+ (path.hashValue &* 3) &+ (version.hashValue &* 5)
    }
}

//MARK: CustomStringConvertable

extension TokenCardDescriptor: CustomStringConvertible {
    public var description: String {
        let consumed = self.isConsumed ? "CONSUMED" : "NOT CONSUMED"
        return "\(name) [\(self.type), \(consumed), version \(self.version)]"
    }
}

//MARK: JSONEncodable

extension TokenCardDescriptor: JSONEncodable {
    public func toJSON() -> JSON {
        return .Dictionary([
            "type": type.toJSON(),
            "name": name.toJSON(),
            "path": path.toJSON(),
            "version": version.toJSON(),
            "assetCatalog": assetCatalog.toJSON(),
            "isConsumed": isConsumed.toJSON()
            ])
    }
}

//MARK: JSONDecodable

extension TokenCardDescriptor: JSONDecodable {
    public init(json: JSON) throws {
        self.name = try json.string("name")
        self.path = try json.decode("path", type: CardPath.self)
        self.version = try json.int("version")
        self.assetCatalog = try json.decode("assetCatalog", type: CardAssetCatalog.self)
        self.isConsumed = try json.bool("isConsumed")
    }
}
