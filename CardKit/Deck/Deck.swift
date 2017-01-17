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

public class Deck {
    /// These are the Hands that are stored at the Deck level.
    /// Hands may also be stored as subhands of a Hand, which means
    /// that this is NOT the complete set of Hands in the deck.
    /// Do not rely on this member providing complete information about all
    /// Hands in the Deck; rather, use the computed properties `hands` and
    /// `handCount`.
    public var deckHands: [Hand]
    
    /// List of Deck cards in the Deck.
    public var deckCards: [DeckCard]
    
    /// List of Token cards in the Deck.
    public var tokenCards: [TokenCard]
    
    public var identifier: DeckIdentifier = DeckIdentifier()
    
    /// Returns the complete set of Hands in the Deck, including
    /// all Hands that are nested in other Hands due to branching logic.
    public var hands: [Hand] {
        var hands: [Hand] = []
        hands.append(contentsOf: self.deckHands)
        self.deckHands.forEach { hands.append(contentsOf: $0.nestedSubhands) }
        return hands
    }
    
    /// Returns the complete number of Hands in the Deck, including
    /// Hands that are nested in other Hands due to branching logic.
    public var handCount: Int {
        return deckHands.count + deckHands.reduce(0) { (count, hand) in
            count + hand.nestedSubhandCount
        }
    }
    
    /// Returns the complete set of Cards in the Deck.
    public var cards: [Card] {
        var cards: [Card] = []
        self.hands.forEach { cards.append(contentsOf: $0.cards) }
        return cards
    }
    
    /// Returns the complete number of Cards in the Deck.
    public var cardCount: Int {
        return self.deckHands.reduce(0) { (count, hand) in
            count + hand.nestedCardCount
        } + self.deckCards.count + self.tokenCards.count
    }
    
    /// Returns the complete set of ActionCards in the Deck.
    public var actionCards: [ActionCard] {
        var cards: [ActionCard] = []
        self.hands.forEach { cards.append(contentsOf: $0.actionCards) }
        return cards
    }
    
    /// Returns the first Hand in the Deck, or nil if there are no
    /// hands in the deck.
    public var firstHand: Hand? {
        return deckHands.first
    }
    
    convenience init() {
        self.init(with: [])
    }
    
    init(with hands: [Hand]) {
        self.deckHands = hands
        self.deckCards = []
        self.tokenCards = []
    }
    
    init(copying deck: Deck) {
        self.deckHands = deck.deckHands
        self.deckCards = deck.deckCards
        self.tokenCards = []
    }
    
    // MARK: JSONEncodable & JSONDecodable
    
    public init(json: JSON) throws {
        self.deckHands = try json.decodedArray(at: "deckHands", type: Hand.self)
        self.deckCards = try json.decodedArray(at: "deckCards", type: DeckCard.self)
        self.tokenCards = try json.decodedArray(at: "tokenCards", type: TokenCard.self)
        self.identifier = try json.decode(at: "identifier", type: DeckIdentifier.self)
    }
    
    public func toJSON() -> JSON {
        return .dictionary([
            "deckHands": self.deckHands.toJSON(),
            "deckCards": self.deckCards.toJSON(),
            "tokenCards": self.tokenCards.toJSON(),
            "identifier": self.identifier.toJSON()
            ])
    }
}

// MARK: Deck Addition

extension Deck {
    /// Add the Hand to the Deck as a top-level Hand (i.e. not nested within any Hands).
    public func add(_ hand: Hand) {
        self.deckHands.append(hand)
    }
    
    /// Add the Deck card to the Deck.
    public func add(_ card: DeckCard) {
        self.deckCards.append(card)
    }
    
    /// Add the Token card to the Deck.
    public func add(_ card: TokenCard) {
        self.tokenCards.append(card)
    }
}

// MARK: Deck Removal

extension Deck {
    /// Remove the Hand from the Deck. Removes the Hand even if it is nested within another Hand.
    public func remove(_ hand: Hand) {
        if self.deckHands.contains(hand) {
            self.deckHands.removeObject(hand)
        } else {
            // find this Hand in a subhand
            for deckHand in self.deckHands {
                deckHand.remove(hand)
            }
        }
    }
    
    /// Remove the Deck card from the Deck.
    public func remove(_ card: DeckCard) {
        self.deckCards.removeObject(card)
    }
    
    /// Remove the Token card from the Deck.
    public func remove(_ card: TokenCard) {
        self.tokenCards.removeObject(card)
    }
}

// MARK: Deck Query

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
    
    /// Returns the Hand with the given CardIdentifier, or nil if no such Hand
    /// exists in the Deck.
    public func hand(with identifier: HandIdentifier) -> Hand? {
        for hand in self.hands {
            if hand.identifier == identifier {
                return hand
            }
        }
        
        return nil
    }
}

// MARK: Equatable

extension Deck: Equatable {
    static public func == (lhs: Deck, rhs: Deck) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

// MARK: Hashable

extension Deck: Hashable {
    public var hashValue: Int {
        return self.identifier.hashValue
    }
}
