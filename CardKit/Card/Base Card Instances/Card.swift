//
//  Card.swift
//  CardKit
//
//  Created by Justin Weisz on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

// MARK: CardIdentifier

/// CardIdentifiers are used to uniquely identify instances of Cards in a Deck to ensure Inputs and Yields are bound to the correct instance.
public struct CardIdentifier: Codable {
    fileprivate let identifier: String
    
    init() {
        identifier = UUID().uuidString
    }
    
    init(identifiedBy identifier: String) {
        self.identifier = identifier
    }
}

// MARK: Equatable

extension CardIdentifier: Equatable {
    static public func == (lhs: CardIdentifier, rhs: CardIdentifier) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

// MARK: Hashable

extension CardIdentifier: Hashable {
    public var hashValue: Int {
        return identifier.hashValue
    }
}

// MARK: CustomStringConvertible

extension CardIdentifier: CustomStringConvertible {
    public var description: String {
        return identifier
    }
}

// MARK: - Card

public protocol Card {
    var identifier: CardIdentifier { get }
    var cardType: CardType { get }
    var description: String { get }
    var assetCatalog: CardAssetCatalog { get }
}
