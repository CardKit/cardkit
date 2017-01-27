//
//  DeckCardDescriptor.swift
//  CardKit
//
//  Created by Justin Weisz on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy

// MARK: DeckCardDescriptor

public struct DeckCardDescriptor: CardDescriptor {
    public let cardType: CardType = .deck
    public let name: String
    public let path: CardPath
    public let assetCatalog: CardAssetCatalog
    
    public init(name: String, subpath: String?, assetCatalog: CardAssetCatalog) {
        self.name = name
        if let subpath = subpath {
            self.path = CardPath(withPath: "Deck/\(subpath)")
        } else {
            self.path = CardPath(withPath: "Deck")
        }
        self.assetCatalog = assetCatalog
    }
    
    /// Return a new DeckCard instance using our descriptor
    func makeCard() -> DeckCard {
        return DeckCard(with: self)
    }
}

// MARK: Equatable

extension DeckCardDescriptor: Equatable {
    /// Card descriptors are equal when their names and paths are the same. All the other metadata should be the same when two descriptors have the same name & path.
    static public func == (lhs: DeckCardDescriptor, rhs: DeckCardDescriptor) -> Bool {
        var equal = true
        equal = equal && lhs.name == rhs.name
        equal = equal && lhs.path == rhs.path
        return equal
    }
}

// MARK: Hashable

extension DeckCardDescriptor: Hashable {
    public var hashValue: Int {
        return name.hashValue &+ (path.hashValue &* 3)
    }
}

// MARK: CustomStringConvertable

extension DeckCardDescriptor: CustomStringConvertible {
    public var description: String {
        return "\(self.path.description)/\(self.name)"
    }
}

// MARK: JSONEncodable

extension DeckCardDescriptor: JSONEncodable {
    public func toJSON() -> JSON {
        return .dictionary([
            "cardType": cardType.toJSON(),
            "name": name.toJSON(),
            "path": path.toJSON(),
            "assetCatalog": assetCatalog.toJSON()
            ])
    }
}

// MARK: JSONDecodable

extension DeckCardDescriptor: JSONDecodable {
    public init(json: JSON) throws {
        self.name = try json.getString(at: "name")
        self.path = try json.decode(at: "path", type: CardPath.self)
        self.assetCatalog = try json.decode(at: "assetCatalog", type: CardAssetCatalog.self)
    }
}
