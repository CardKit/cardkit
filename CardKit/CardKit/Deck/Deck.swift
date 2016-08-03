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
    
    let identifier: DeckIdentifier
    
    init() {
        self.init(hands: [])
    }
    
    init(hands: [Hand]) {
        self.hands = hands
        self.deckCards = []
        self.identifier = DeckIdentifier()
    }
    
    var handCount: Int {
        return hands.count
    }
    
    var firstHand: Hand? {
        return hands.first
    }
    
    mutating func add(hand: Hand) {
        self.hands.append(hand)
    }
    
    mutating func add(card: DeckCard) {
        self.deckCards.append(card)
    }
    
    mutating func remove(hand: Hand) {
        self.hands.removeObject(hand)
    }
    
    mutating func remove(card: DeckCard) {
        self.deckCards.removeObject(card)
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
        self.identifier = try json.decode("identifier", type: DeckIdentifier.self)
    }
}

//MARK: JSONEncodable

extension Deck: JSONEncodable {
    public func toJSON() -> JSON {
        return .Dictionary([
            "hands": self.hands.toJSON(),
            "deckCards": self.deckCards.toJSON(),
            "identifier": self.identifier.toJSON()
            ])
    }
}
