//
//  DeckCardDescriptor.swift
//  CardKit
//
//  Created by Justin Weisz on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy

//MARK: DeckCardDescriptor

public struct DeckCardDescriptor: CardDescriptor {
    public let cardType: CardType = .Deck
    public let name: String
    public let path: CardPath
    public let version: Int
    public let assetCatalog: CardAssetCatalog
    
    public init(name: String, subpath: String?, assetCatalog: CardAssetCatalog, version: Int = 0) {
        self.name = name
        self.path = CardPath(withPath: "Deck/\(subpath)" ?? "Deck")
        self.version = version
        self.assetCatalog = assetCatalog
    }
    
    /// Return a new DeckCard instance using our descriptor
    func makeCard() -> DeckCard {
        return DeckCard(with: self)
    }
}

//MARK: Equatable

extension DeckCardDescriptor: Equatable {}

/// Card descriptors are equal when their names, paths, and versions are the same. All the other metadata should be the same when two descriptors have the same name, path, & version.
public func == (lhs: DeckCardDescriptor, rhs: DeckCardDescriptor) -> Bool {
    var equal = true
    equal = equal && lhs.name == rhs.name
    equal = equal && lhs.path == rhs.path
    equal = equal && lhs.version == rhs.version
    return equal
}


//MARK: Hashable

extension DeckCardDescriptor: Hashable {
    public var hashValue: Int {
        return name.hashValue &+ (path.hashValue &* 3) &+ (version.hashValue &* 5)
    }
}

//MARK: CustomStringConvertable

extension DeckCardDescriptor: CustomStringConvertible {
    public var description: String {
        return "\(name) [\(self.cardType), version \(self.version)]"
    }
}

//MARK: JSONEncodable

extension DeckCardDescriptor: JSONEncodable {
    public func toJSON() -> JSON {
        return .Dictionary([
            "cardType": cardType.toJSON(),
            "name": name.toJSON(),
            "path": path.toJSON(),
            "version": version.toJSON(),
            "assetCatalog": assetCatalog.toJSON()
            ])
    }
}

//MARK: JSONDecodable

extension DeckCardDescriptor: JSONDecodable {
    public init(json: JSON) throws {
        self.name = try json.string("name")
        self.path = try json.decode("path", type: CardPath.self)
        self.version = try json.int("version")
        self.assetCatalog = try json.decode("assetCatalog", type: CardAssetCatalog.self)
    }
}