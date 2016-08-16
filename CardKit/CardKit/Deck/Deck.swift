//
//  Deck.swift
//  CardKit
//
//  Created by Justin Weisz on 7/28/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy

public typealias DeckIdentifier = CardIdentifier

public struct Deck {
    public var hands: [Hand]
    public var deckCards: [DeckCard]
    public var tokenCards: [TokenCard]
    
    public var identifier: DeckIdentifier = DeckIdentifier()
    
    init() {
        self.init(with: [])
    }
    
    init(with hands: [Hand]) {
        self.hands = hands
        self.deckCards = []
        self.tokenCards = []
    }
    
    init(copying deck: Deck) {
        self.hands = deck.hands
        self.deckCards = deck.deckCards
        self.tokenCards = []
    }
    
    var handCount: Int {
        return hands.count
    }
    
    var cardCount: Int {
        return hands.reduce(0, combine: {(count, hand) in count + hand.cardCount}) + self.deckCards.count + self.tokenCards.count
    }
    
    var firstHand: Hand? {
        return hands.first
    }
}

//MARK: Deck Addition

extension Deck {
    mutating func add(hand: Hand) {
        self.hands.append(hand)
    }
    
    mutating func add(card: DeckCard) {
        self.deckCards.append(card)
    }
    
    mutating func add(card: TokenCard) {
        self.tokenCards.append(card)
    }
}

//MARK: Deck Removal

extension Deck {
    mutating func remove(hand: Hand) {
        self.hands.removeObject(hand)
    }
    
    mutating func remove(card: DeckCard) {
        self.deckCards.removeObject(card)
    }
    
    mutating func remove(card: TokenCard) {
        self.tokenCards.removeObject(card)
    }
}

//MARK: Deck Query

extension Deck {
    /// Returns the TokenCard with the given CardIdentifier, or nil if no such
    /// TokenCard exists in the Deck.
    public func tokenCard(with identifier: CardIdentifier) -> TokenCard? {
        for tokenCard in self.tokenCards {
            if tokenCard.identifier == identifier {
                return tokenCard
            }
        }
        return nil
    }
}

//MARK: Equatable

extension Deck: Equatable {}

public func == (lhs: Deck, rhs: Deck) -> Bool {
    return lhs.identifier == rhs.identifier
}

//MARK: Hashable

extension Deck: Hashable {
    public var hashValue: Int {
        return self.identifier.hashValue
    }
}

//MARK: JSONDecodable

extension Deck: JSONDecodable {
    public init(json: JSON) throws {
        self.hands = try json.arrayOf("hands", type: Hand.self)
        self.deckCards = try json.arrayOf("deckCards", type: DeckCard.self)
        self.tokenCards = try json.arrayOf("tokenCards", type: TokenCard.self)
        self.identifier = try json.decode("identifier", type: DeckIdentifier.self)
    }
}

//MARK: JSONEncodable

extension Deck: JSONEncodable {
    public func toJSON() -> JSON {
        return .Dictionary([
            "hands": self.hands.toJSON(),
            "deckCards": self.deckCards.toJSON(),
            "tokenCards": self.tokenCards.toJSON(),
            "identifier": self.identifier.toJSON()
            ])
    }
}
