//
//  TokenCardDescriptor.swift
//  CardKit
//
//  Created by Justin Weisz on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy

// MARK: TokenCardDescriptor

public struct TokenCardDescriptor: CardDescriptor, Consumable {
    public let cardType: CardType = .token
    public let name: String
    public let path: CardPath
    public let assetCatalog: CardAssetCatalog
    
    public let isConsumed: Bool
    
    public init(name: String, subpath: String?, isConsumed: Bool, assetCatalog: CardAssetCatalog) {
        self.name = name
        if let subpath = subpath {
            self.path = CardPath(withPath: "Token/\(subpath)")
        } else {
            self.path = CardPath(withPath: "Token")
        }
        self.assetCatalog = assetCatalog
        
        self.isConsumed = isConsumed
    }
    
    /// Return a new TokenCard instance using our descriptor
    public func makeCard() -> TokenCard {
        return TokenCard(with: self)
    }
}

// MARK: Equatable

extension TokenCardDescriptor: Equatable {
    /// Card descriptors are equal when their names and paths are the same. All the other metadata should be the same when two descriptors have the same name & path.
    static public func == (lhs: TokenCardDescriptor, rhs: TokenCardDescriptor) -> Bool {
        var equal = true
        equal = equal && lhs.name == rhs.name
        equal = equal && lhs.path == rhs.path
        return equal
    }
}

// MARK: Hashable

extension TokenCardDescriptor: Hashable {
    public var hashValue: Int {
        return name.hashValue &+ (path.hashValue &* 3)
    }
}

// MARK: CustomStringConvertable

extension TokenCardDescriptor: CustomStringConvertible {
    public var description: String {
        return "\(self.path.description)/\(self.name)"
    }
}

// MARK: JSONEncodable

extension TokenCardDescriptor: JSONEncodable {
    public func toJSON() -> JSON {
        return .dictionary([
            "cardType": cardType.toJSON(),
            "name": name.toJSON(),
            "path": path.toJSON(),
            "assetCatalog": assetCatalog.toJSON(),
            "isConsumed": isConsumed.toJSON()
            ])
    }
}

// MARK: JSONDecodable

extension TokenCardDescriptor: JSONDecodable {
    public init(json: JSON) throws {
        self.name = try json.getString(at: "name")
        self.path = try json.decode(at: "path", type: CardPath.self)
        self.assetCatalog = try json.decode(at: "assetCatalog", type: CardAssetCatalog.self)
        self.isConsumed = try json.getBool(at: "isConsumed")
    }
}
