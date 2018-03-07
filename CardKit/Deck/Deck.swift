/**
 * Copyright 2018 IBM Corp. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Foundation

public typealias DeckIdentifier = CardIdentifier

public class Deck: Codable {
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
    
    public convenience init() {
        self.init(with: [])
    }
    
    public init(with hands: [Hand]) {
        self.deckHands = hands
        self.deckCards = []
        self.tokenCards = []
    }
    
    public init(copying deck: Deck) {
        self.deckHands = deck.deckHands
        self.deckCards = deck.deckCards
        self.tokenCards = []
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
    
    /// Add the Token card to the Deck.
    public func add(_ cards: [TokenCard]) {
        self.tokenCards.append(contentsOf: cards)
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
