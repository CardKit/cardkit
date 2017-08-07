//
//  TokenCardDescriptor.swift
//  CardKit
//
//  Created by Justin Weisz on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

// MARK: TokenCardDescriptor

public struct TokenCardDescriptor: CardDescriptor, Consumable, Codable {
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
    /// Card descriptors are equal when their names and paths are the same.
    /// All the other metadata should be the same when two descriptors have the same name & path.
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
