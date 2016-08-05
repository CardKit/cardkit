//
//  Hand.swift
//  CardKit
//
//  Created by Justin Weisz on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy

public typealias HandIdentifier = CardIdentifier

public struct Hand {
    // implementing these as arrays rather than sets because the order 
    // in which a card is added might matter
    public var actionCards: [ActionCard] = []
    public var handCards: [HandCard] = []
    
    public var identifier: HandIdentifier = HandIdentifier()
    
    var cards: [Card] {
        var c: [Card] = []
        c.appendContentsOf(actionCards.map({ $0 as Card }))
        c.appendContentsOf(handCards.map({ $0 as Card }))
        return c
    }
    
    /// The number of cards in a hand includes all Action and Hand
    /// cards added to the hand, plus any Input or Token cards that
    /// are bound to the Action cards.
    var cardCount: Int {
        // find all Input cards bound to the action cards
        // note that we do not count Token card bindings, as Token cards
        // are kept at the Deck level
        let boundCount = actionCards.reduce(0) {
            (count, card: ActionCard) in
            count + card.inputBindings.count
        }
        
        return actionCards.count + handCards.count + boundCount
    }
}

//MARK: Card Addition

extension Hand {
    /// Add the card to the hand if it isn't in the hand already.
    mutating func add(card: ActionCard) {
        if !self.contains(card) {
            self.actionCards.append(card)
        }
    }
    
    /// Add the given cards to the hand, ignoring cards that have already
    /// been added to the hand.
    mutating func add(cards: [ActionCard]) {
        // only add cards that aren't currently in our hand
        let uniques = cards.filter({ (card) -> Bool in !self.contains(card) })
        self.actionCards.appendContentsOf(uniques)
    }
    
    /// Add the card to the hand if it isn't in the hand already.
    mutating func add(card: HandCard) {
        if !self.contains(card) {
            self.handCards.append(card)
        }
    }
    
    /// Add the given cards to the hand, ignoring cards that have already
    /// been added to the hand.
    mutating func add(cards: [HandCard]) {
        // only add cards that aren't currently in our hand
        let uniques = cards.filter({ (card) -> Bool in !self.contains(card) })
        self.handCards.appendContentsOf(uniques)
    }
    
    /// Add the cards from the given hand to this hand. Ignores cards that are
    /// already in this hand.
    mutating func addCards(from hand: Hand) {
        hand.actionCards.forEach({ (card) in self.add(card) })
        hand.handCards.forEach({ (card) in self.add(card) })
    }
}

//MARK: Card Removal

extension Hand {
    /// Remove the given card from the hand.
    mutating func remove(card: ActionCard) {
        self.actionCards.removeObject(card)
    }
    
    /// Remove the given cards from the hand.
    mutating func remove(cards: [ActionCard]) {
        cards.forEach({ (card) in self.actionCards.removeObject(card) })
    }
    
    /// Remove the given card from the hand.
    mutating func remove(card: HandCard) {
        self.handCards.removeObject(card)
    }
    
    /// Remove the given cards from the hand.
    mutating func remove(cards: [HandCard]) {
        cards.forEach({ (card) in self.handCards.removeObject(card) })
    }
    
    /// Remove all cards from the hand.
    mutating func removeAll() {
        self.actionCards.removeAll()
        self.handCards.removeAll()
    }
}

//MARK: Card Query

extension Hand {
    /// Returns true if the hand contains the given card.
    func contains(card: ActionCard) -> Bool {
        return self.actionCards.indexOf(card) != nil
    }
    
    /// Returns true if the hand contains the given card.
    func contains(card: HandCard) -> Bool {
        return self.handCards.indexOf(card) != nil
    }
    
    /// Returns the set of ActionCards with the given descriptor.
    func cards(matching descriptor: ActionCardDescriptor) -> [ActionCard] {
        return self.actionCards.filter({
            (card) -> Bool in
            card.descriptor == descriptor
        })
    }
    
    /// Returns the set of HandCards with the given descriptor.
    func cards(matching descriptor: HandCardDescriptor) -> [HandCard] {
        return self.handCards.filter({
            (card) -> Bool in
            card.descriptor == descriptor
        })
    }
}

//MARK: Equatable

extension Hand: Equatable {}

/// Hands are considered equal when they have the same identifier (even if their
/// contents are different.)
public func == (lhs: Hand, rhs: Hand) -> Bool {
    return lhs.identifier == rhs.identifier
}

//MARK: Hashable

extension Hand: Hashable {
    public var hashValue: Int {
        return self.identifier.hashValue
    }
}

//MARK: JSONDecodable

extension Hand: JSONDecodable {
    public init(json: JSON) throws {
        self.actionCards = try json.arrayOf("actionCards", type: ActionCard.self)
        self.handCards = try json.arrayOf("handCards", type: HandCard.self)
        self.identifier = try json.decode("identifier", type: HandIdentifier.self)
    }
}

//MARK: JSONEncodable

extension Hand: JSONEncodable {
    public func toJSON() -> JSON {
        return .Dictionary([
            "actionCards": self.actionCards.toJSON(),
            "handCards": self.handCards.toJSON(),
            "identifier": self.identifier.toJSON(),
            ])
    }
}
