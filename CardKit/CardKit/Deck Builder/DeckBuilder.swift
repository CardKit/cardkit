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
    
    // create a NOT card bound to the operand
    if let notCard: LogicHandCard = CardKit.Hand.Logic.LogicalNot.typedInstance() {
        hand.attach(operand, to: notCard)
    }
    
    return hand
}


//MARK: And Operations

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
    
    // create an AND card bound to the operands
    if let andCard: LogicHandCard = CardKit.Hand.Logic.LogicalAnd.typedInstance() {
        hand.attach(lhs, to: andCard)
        hand.attach(rhs, to: andCard)
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

/// Returns a new hand with the given hands combined together using AND logic. This works by
/// collapsing all CardTrees in each hand using the logical operator specified by the End Rule
/// (AND for EndWhenAllSatisfied, OR for EndWhenAnySatisfied), and then ANDing the singular-
/// trees in lhs and rhs. Branch cards are removed in this operation because the CardTrees are no
/// longer valid. All other cards (Hand, Repeat, End Rule) are copied into the
/// new Hand, with rhs having precedence when there are conflicts.
public func && (lhs: Hand, rhs: Hand) -> Hand {
    print("AND(H,H): \(lhs.identifier) && \(rhs.identifier)")
    return lhs.collapsed(combiningWith: rhs, usingLogicalOperation: .BooleanAnd)
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
    if let orCard: LogicHandCard = CardKit.Hand.Logic.LogicalOr.typedInstance() {
        hand.attach(lhs, to: orCard)
        hand.attach(rhs, to: orCard)
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

/// Returns a new hand with the given hands combined together using OR logic. This works by
/// collapsing all CardTrees in each hand using the logical operator specified by the End Rule
/// (AND for EndWhenAllSatisfied, OR for EndWhenAnySatisfied), and then ORing the singular-
/// trees in lhs and rhs. Branch cards are removed in this operation because the CardTrees are no
/// longer valid. All other cards (Hand, Repeat, End Rule) are copied into the
/// new Hand, with rhs having precedence when there are conflicts.
public func || (lhs: Hand, rhs: Hand) -> Hand {
    print("OR(H,H): \(lhs.identifier) && \(rhs.identifier)")
    return lhs.collapsed(combiningWith: rhs, usingLogicalOperation: .BooleanOr)
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
    return lhs.merged(with: rhs)
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
