//
//  DeckBuilder.swift
//  CardKit
//
//  Created by Justin Weisz on 8/3/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation


//MARK: Binding Operator

infix operator <- { associativity right precedence 160 }


//MARK: Binding Data to an InputCard

public func <-<T> (lhs: InputCardDescriptor, rhs: T) throws -> InputCard {
    return try lhs.instance() <- rhs
}

/// Bind data to an InputCard
public func <-<T> (lhs: InputCard, rhs: T) throws -> InputCard {
    return try lhs.bound(withValue: rhs)
}

//MARK: Binding Input & Token Cards to Action Cards

/// Try binding an InputCard to an ActionCardDescriptor. Creates a new
/// ActionCard instance first.
public func <- (lhs: ActionCardDescriptor, rhs: InputCard) throws -> ActionCard {
    return try lhs.instance() <- rhs
}

/// Try binding an InputCard to an ActionCard, looking for the first
/// available InputSlot that matches the InputCard's InputType
public func <- (lhs: ActionCard, rhs: InputCard) throws -> ActionCard {
    return try lhs.bound(with: rhs)
}

/// Bind a TokenCard to an ActionCardDescriptor. Creates a new ActionCard
/// instance first.
public func <- (lhs: ActionCardDescriptor, rhs: (TokenIdentifier, TokenCard)) throws -> ActionCard {
    return try lhs.instance() <- rhs
}

/// Bind a TokenCard to an ActionCard in the specified slot
public func <- (lhs: ActionCard, rhs: (TokenIdentifier, TokenCard)) throws -> ActionCard {
    return try lhs.bound(with: rhs.1, toSlotWithIdentifier: rhs.0)
}


//MARK: Not Operation

/// Return a new hand with the given ActionCard and a Not card played with it
public prefix func ! (operand: ActionCardDescriptor) -> Hand {
    return !operand.instance()
}

/// Return a new hand with the given ActionCard and a Not card played with it
public prefix func ! (operand: ActionCard) -> Hand {
    // create a new Hand
    var hand = Hand()
    hand.add(operand)
    
    // create a NOT card bound to the operand
    if let notCard = CardKit.Hand.Logic.LogicalNot.instance() as? UnaryLogicHandCard {
        notCard.operand = operand.identifier
        hand.add(notCard)
    }
    
    return hand
}


//MARK: And Operations

infix operator && { associativity left precedence 150 }

public func && (lhs: ActionCardDescriptor, rhs: ActionCardDescriptor) -> Hand {
    return lhs.instance() && rhs.instance()
}

public func && (lhs: ActionCardDescriptor, rhs: ActionCard) -> Hand {
    return lhs.instance() && rhs
}

public func && (lhs: ActionCard, rhs: ActionCardDescriptor) -> Hand {
    return lhs && rhs.instance()
}

/// Return a new hand with the given ActionCards ANDed together
public func && (lhs: ActionCard, rhs: ActionCard) -> Hand {
    print("AND(A,A): \(lhs.identifier) && \(rhs.identifier)")
    // create a new Hand
    var hand = Hand()
    hand.add(lhs)
    hand.add(rhs)
    
    // create an AND card bound to the operands
    if let andCard = CardKit.Hand.Logic.LogicalAnd.instance() as? BinaryLogicHandCard {
        andCard.lhs = lhs.identifier
        andCard.rhs = rhs.identifier
        hand.add(andCard)
    }
    
    return hand
}

public func && (lhs: Hand, rhs: ActionCardDescriptor) -> Hand {
    return lhs && rhs.instance()
}

public func && (lhs: Hand, rhs: ActionCard) -> Hand {
    print("AND(H,A): \(lhs.identifier) && \(rhs.identifier)")
    var hand = Hand()
    hand.add(rhs)
    return lhs && hand
}

public func && (lhs: ActionCardDescriptor, rhs: Hand) -> Hand {
    return lhs.instance() && rhs
}

public func && (lhs: ActionCard, rhs: Hand) -> Hand {
    print("AND(A,H): \(lhs.identifier) && \(rhs.identifier)")
    var hand = Hand()
    hand.add(lhs)
    return rhs && hand
}

/// Return a new hand with the given hands ANDed together. This works by creating a new
/// AND card. The AND card will have lhs and rhs set to either: 
/// (1) the most recently-added Logic Hand card (AND, OR, NOT), or 
/// (2) the most recently-added ActionCard.
/// Thus, if the last logic card of hand A is X = (A v B) ^ !D and the last logic card 
/// of hand B is Y = !C, the new hand will have a logic of X ^ Y.
public func && (lhs: Hand, rhs: Hand) -> Hand {
    print("AND(H,H): \(lhs.identifier) && \(rhs.identifier)")
    
    var lhsTarget: CardIdentifier? = nil
    var rhsTarget: CardIdentifier? = nil
    
    for card in lhs.handCards.reverse() {
        if card.descriptor.operation == .BooleanLogicAnd || card.descriptor.operation == .BooleanLogicOr || card.descriptor.operation == .BooleanLogicNot {
            lhsTarget = card.identifier
            break
        }
    }
    
    for card in rhs.handCards.reverse() {
        if card.descriptor.operation == .BooleanLogicAnd || card.descriptor.operation == .BooleanLogicOr || card.descriptor.operation == .BooleanLogicNot {
            rhsTarget = card.identifier
            break
        }
    }
    
    if lhsTarget == nil {
        lhsTarget = lhs.actionCards.last?.identifier
    }
    
    if rhsTarget == nil {
        rhsTarget = rhs.actionCards.last?.identifier
    }
    
    // create the AND card -- note if lhs or rhs are still nil, then
    // we might be ANDing an empty hand, which is okay, since later on
    // the AND targets could be bound
    // make a new hand
    var hand = Hand()
    hand.addCards(from: lhs)
    hand.addCards(from: rhs)
    
    // bind them all together
    if let andCard = CardKit.Hand.Logic.LogicalAnd.instance() as? BinaryLogicHandCard {
        if let lhs = lhsTarget {
            andCard.lhs = lhs
        }
        if let rhs = rhsTarget {
            andCard.rhs = rhs
        }
        hand.add(andCard)
    }
    
    return hand
}

//MARK: Or Operations

public func || (lhs: ActionCardDescriptor, rhs: ActionCardDescriptor) -> Hand {
    return lhs.instance() || rhs.instance()
}

public func || (lhs: ActionCardDescriptor, rhs: ActionCard) -> Hand {
    return lhs.instance() || rhs
}

public func || (lhs: ActionCard, rhs: ActionCardDescriptor) -> Hand {
    return lhs || rhs.instance()
}

/// Return a new hand with the given ActionCards ORed together
public func || (lhs: ActionCard, rhs: ActionCard) -> Hand {
    print("OR(A,A): \(lhs.identifier) && \(rhs.identifier)")
    // create a new Hand
    var hand = Hand()
    hand.add(lhs)
    hand.add(rhs)
    
    // create an OR card bound to the operands
    if let orCard = CardKit.Hand.Logic.LogicalOr.instance() as? BinaryLogicHandCard {
        orCard.lhs = lhs.identifier
        orCard.rhs = rhs.identifier
        hand.add(orCard)
    }
    
    return hand
}

public func || (lhs: Hand, rhs: ActionCardDescriptor) -> Hand {
    return lhs || rhs.instance()
}

public func || (lhs: Hand, rhs: ActionCard) -> Hand {
    print("OR(H,A): \(lhs.identifier) && \(rhs.identifier)")
    var hand = Hand()
    hand.add(rhs)
    return lhs || hand
}

public func || (lhs: ActionCardDescriptor, rhs: Hand) -> Hand {
    return lhs.instance() || rhs
}

public func || (lhs: ActionCard, rhs: Hand) -> Hand {
    print("OR(A,H): \(lhs.identifier) && \(rhs.identifier)")
    var hand = Hand()
    hand.add(lhs)
    return rhs || hand
}

/// Return a new hand with the given hands ORed together. This works by creating a new
/// OR card. The OR card will have lhs and rhs set to either:
/// (1) the most recently-added Logic Hand card (AND, OR, NOT), or
/// (2) the most recently-added ActionCard.
/// Thus, if the last logic card of hand A is X = (A v B) ^ !D and the last logic card
/// of hand B is Y = !C, the new hand will have a logic of X v Y.
public func || (lhs: Hand, rhs: Hand) -> Hand {
    print("OR(H,H): \(lhs.identifier) && \(rhs.identifier)")
    
    var lhsTarget: CardIdentifier? = nil
    var rhsTarget: CardIdentifier? = nil
    
    for card in lhs.handCards.reverse() {
        if card.descriptor.operation == .BooleanLogicAnd || card.descriptor.operation == .BooleanLogicOr || card.descriptor.operation == .BooleanLogicNot {
            lhsTarget = card.identifier
            break
        }
    }
    
    for card in rhs.handCards.reverse() {
        if card.descriptor.operation == .BooleanLogicAnd || card.descriptor.operation == .BooleanLogicOr || card.descriptor.operation == .BooleanLogicNot {
            rhsTarget = card.identifier
            break
        }
    }
    
    if lhsTarget == nil {
        lhsTarget = lhs.actionCards.last?.identifier
    }
    
    if rhsTarget == nil {
        rhsTarget = rhs.actionCards.last?.identifier
    }
    
    // create the OR card -- note if lhs or rhs are still nil, then
    // we might be ORing an empty hand, which is okay, since later on
    // the OR targets could be bound
    // make a new hand
    var hand = Hand()
    hand.addCards(from: lhs)
    hand.addCards(from: rhs)
    
    // bind them all together
    if let orCard = CardKit.Hand.Logic.LogicalOr.instance() as? BinaryLogicHandCard {
        if let lhs = lhsTarget {
            orCard.lhs = lhs
        }
        if let rhs = rhsTarget {
            orCard.rhs = rhs
        }
        hand.add(orCard)
    }
    
    return hand
}


//MARK: Adding Cards to a Hand

public func + (lhs: ActionCardDescriptor, rhs: ActionCardDescriptor) -> Hand {
    return lhs.instance() + rhs.instance()
}

public func + (lhs: ActionCardDescriptor, rhs: ActionCard) -> Hand {
    return lhs.instance() + rhs
}

public func + (lhs: ActionCard, rhs: ActionCardDescriptor) -> Hand {
    return lhs + rhs.instance()
}

public func + (lhs: ActionCard, rhs: ActionCard) -> Hand {
    print("ADD(A,A): \(lhs.identifier) && \(rhs.identifier)")
    var hand = Hand()
    hand.add(lhs)
    hand.add(rhs)
    return hand
}

public func + (lhs: Hand, rhs: ActionCardDescriptor) -> Hand {
    return lhs + rhs.instance()
}

public func + (lhs: Hand, rhs: ActionCard) -> Hand {
    print("ADD(H,A): \(lhs.identifier) && \(rhs.identifier)")
    var hand = lhs
    hand.add(rhs)
    return hand
}

public func + (lhs: HandCardDescriptor, rhs: HandCardDescriptor) -> Hand {
    return lhs.instance() + rhs.instance()
}

public func + (lhs: HandCardDescriptor, rhs: HandCard) -> Hand {
    return lhs.instance() + rhs
}

public func + (lhs: HandCard, rhs: HandCardDescriptor) -> Hand {
    return lhs + rhs.instance()
}

public func + (lhs: HandCard, rhs: HandCard) -> Hand {
    var hand = Hand()
    hand.add(lhs)
    hand.add(rhs)
    return hand
}

public func + (lhs: Hand, rhs: HandCardDescriptor) -> Hand {
    return lhs + rhs.instance()
}

public func + (lhs: Hand, rhs: HandCard) -> Hand {
    var hand = lhs
    hand.add(rhs)
    return hand
}


//MARK: Merging Hands Together

public func + (lhs: Hand, rhs: Hand) -> Hand {
    print("ADD(H,H): \(lhs.identifier) && \(rhs.identifier)")
    var hand = Hand()
    hand.addCards(from: lhs)
    hand.addCards(from: rhs)
    return hand
}


//MARK: Sequencing Hands

infix operator ==> { associativity right precedence 80 }

public func ==> (lhs: ActionCardDescriptor, rhs: ActionCardDescriptor) -> [Hand] {
    return lhs.instance() ==> rhs.instance()
}

public func ==> (lhs: ActionCardDescriptor, rhs: ActionCard) -> [Hand] {
    return lhs.instance() ==> rhs
}

public func ==> (lhs: ActionCard, rhs: ActionCardDescriptor) -> [Hand] {
    return lhs ==> rhs.instance()
}

/// Return a new deck with lhs and rhs as separate hands
public func ==> (lhs: ActionCard, rhs: ActionCard) -> [Hand] {
    var lhsHand = Hand()
    lhsHand.add(lhs)
    var rhsHand = Hand()
    rhsHand.add(rhs)
    return [lhsHand, rhsHand]
}

public func ==> (lhs: ActionCardDescriptor, rhs: Hand) -> [Hand] {
    return lhs.instance() ==> rhs
}

public func ==> (lhs: ActionCard, rhs: Hand) -> [Hand] {
    var lhsHand = Hand()
    lhsHand.add(lhs)
    return [lhsHand, rhs]
}

public func ==> (lhs: Hand, rhs: ActionCardDescriptor) -> [Hand] {
    return lhs ==> rhs.instance()
}

public func ==> (lhs: Hand, rhs: ActionCard) -> [Hand] {
    var rhsHand = Hand()
    rhsHand.add(rhs)
    return [lhs, rhsHand]
}

public func ==> (lhs: Hand, rhs: Hand) -> [Hand] {
    return [lhs, rhs]
}

public func ==> (lhs: ActionCardDescriptor, rhs: [Hand]) -> [Hand] {
    return lhs.instance() ==> rhs
}

public func ==> (lhs: ActionCard, rhs: [Hand]) -> [Hand] {
    var hand = Hand()
    hand.add(lhs)
    
    var hands: [Hand] = []
    hands.append(hand)
    hands.appendContentsOf(rhs)
    return hands
}

public func ==> (lhs: HandCardDescriptor, rhs: [Hand]) -> [Hand] {
    return lhs.instance() ==> rhs
}

public func ==> (lhs: HandCard, rhs: [Hand]) -> [Hand] {
    var hand = Hand()
    hand.add(lhs)
    
    var hands: [Hand] = []
    hands.append(hand)
    hands.appendContentsOf(rhs)
    return hands
}


//MARK: Deckification

postfix operator % {}

/// Seals a deck with a given Hand
public postfix func % (operand: Hand) -> Deck {
    return [operand]%
}

/// Seals a deck with the given set of hands
public postfix func % (operand: [Hand]) -> Deck {
    var deck = Deck()
    deck.hands = operand
    return deck
}


//MARK: Adding DeckCards to a Deck

/// Adds an instance of DeckCardDescriptor to a Deck
public func + (lhs: Deck, rhs: DeckCardDescriptor) -> Deck {
    var deck = Deck(copying: lhs)
    deck.add(rhs.instance())
    return deck
}

/// Adds a DeckCard to a Deck
public func + (lhs: Deck, rhs: DeckCard) -> Deck {
    var deck = Deck(copying: lhs)
    deck.add(rhs)
    return deck
}
