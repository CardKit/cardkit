//
//  DeckBuilder.swift
//  CardKit
//
//  Created by Justin Weisz on 8/3/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation


//MARK: Binding Operator

infix operator <- { associativity right precedence 130 }


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

prefix operator ! {}

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
    if let notCard = CardKit.Hand.Logic.LogicalNot.instance() as? LogicHandCard {
        notCard.children.append(operand.identifier)
        hand.add(notCard)
    }
    
    return hand
}


//MARK: And Operations

infix operator && { associativity right precedence 120 }

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
    // create a new Hand
    var hand = Hand()
    hand.add(lhs)
    hand.add(rhs)
    
    // create an AND card bound to the operands
    if let andCard = CardKit.Hand.Logic.LogicalAnd.instance() as? LogicHandCard {
        andCard.children.append(lhs.identifier)
        andCard.children.append(rhs.identifier)
        hand.add(andCard)
    }
    
    return hand
}

public func && (lhs: Hand, rhs: ActionCardDescriptor) -> Hand {
    return lhs && rhs.instance()
}

public func && (lhs: Hand, rhs: ActionCard) -> Hand {
    var hand = Hand()
    hand.add(rhs)
    return lhs && hand
}

/// Return a new hand with the given hands ANDed together. This works by creating a new
/// AND card with an AND condition that includes all of the _logic_ cards and 
/// _unbound action cards_ from each hand. Thus, if the logic of hand A is
/// [(A v B) ^ !D, E] and the logic of hand B is [!C], the new hand will have a logic
/// of [((A v B) ^ !D) ^ E ^ !C].
public func && (lhs: Hand, rhs: Hand) -> Hand {
    var lhsBound: Set<CardIdentifier> = Set()
    var lhsWillBind: Set<CardIdentifier> = Set()
    
    // build the set of cards that are bound by logic in lhs
    lhs.cards.forEach({
        (card) in
        
        if let logicCard = card as? LogicHandCard {
            lhsWillBind.insert(logicCard.identifier)
            logicCard.children.forEach({ (child) in lhsBound.insert(child) })
        }
    })
    
    // find all unbound action cards
    lhs.cards.forEach({
        (card) in
        
        if let actionCard = card as? ActionCard {
            if !lhsBound.contains(actionCard.identifier) {
                lhsWillBind.insert(actionCard.identifier)
            }
        }
    })
    
    // do the same for rhs
    var rhsBound: Set<CardIdentifier> = Set()
    var rhsWillBind: Set<CardIdentifier> = Set()
    
    // build the set of cards that are bound by logic in rhs
    rhs.cards.forEach({
        (card) in
        
        if let logicCard = card as? LogicHandCard {
            rhsWillBind.insert(logicCard.identifier)
            logicCard.children.forEach({ (child) in rhsBound.insert(child) })
        }
    })
    
    // find all unbound action cards
    rhs.cards.forEach({
        (card) in
        
        if let actionCard = card as? ActionCard {
            if !rhsBound.contains(actionCard.identifier) {
                rhsWillBind.insert(actionCard.identifier)
            }
        }
    })
    
    // make a new hand
    var hand = Hand()
    hand.addCards(from: lhs)
    hand.addCards(from: rhs)
    
    // bind them all together
    if let andCard = CardKit.Hand.Logic.LogicalAnd.instance() as? LogicHandCard {
        andCard.children.appendContentsOf(lhsWillBind)
        andCard.children.appendContentsOf(rhsWillBind)
        hand.add(andCard)
    }
    
    return hand
}

//MARK: Or Operations

infix operator || { associativity right precedence 120 }

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
    // create a new Hand
    var hand = Hand()
    hand.add(lhs)
    hand.add(rhs)
    
    // create an OR card bound to the operands
    if let orCard = CardKit.Hand.Logic.LogicalAnd.instance() as? LogicHandCard {
        orCard.children.append(lhs.identifier)
        orCard.children.append(rhs.identifier)
        hand.add(orCard)
    }
    
    return hand
}

public func || (lhs: Hand, rhs: ActionCardDescriptor) -> Hand {
    return lhs || rhs.instance()
}

public func || (lhs: Hand, rhs: ActionCard) -> Hand {
    var hand = Hand()
    hand.add(rhs)
    return lhs || hand
}

/// Return a new hand with the given hands ORed together. This works by creating a new
/// OR card with an OR condition that includes all of the _logic_ cards and
/// _unbound action cards_ from each hand. Thus, if the logic of hand A is
/// [(A v B) ^ !D, E] and the logic of hand B is [!C], the new hand will have a logic
/// of [((A v B) ^ !D) || E || !C].
public func || (lhs: Hand, rhs: Hand) -> Hand {
    var lhsBound: Set<CardIdentifier> = Set()
    var lhsWillBind: Set<CardIdentifier> = Set()
    
    // build the set of cards that are bound by logic in lhs
    lhs.cards.forEach({
        (card) in
        
        if let logicCard = card as? LogicHandCard {
            lhsWillBind.insert(logicCard.identifier)
            logicCard.children.forEach({ (child) in lhsBound.insert(child) })
        }
    })
    
    // find all unbound action cards
    lhs.cards.forEach({
        (card) in
        
        if let actionCard = card as? ActionCard {
            if !lhsBound.contains(actionCard.identifier) {
                lhsWillBind.insert(actionCard.identifier)
            }
        }
    })
    
    // do the same for rhs
    var rhsBound: Set<CardIdentifier> = Set()
    var rhsWillBind: Set<CardIdentifier> = Set()
    
    // build the set of cards that are bound by logic in rhs
    rhs.cards.forEach({
        (card) in
        
        if let logicCard = card as? LogicHandCard {
            rhsWillBind.insert(logicCard.identifier)
            logicCard.children.forEach({ (child) in rhsBound.insert(child) })
        }
    })
    
    // find all unbound action cards
    rhs.cards.forEach({
        (card) in
        
        if let actionCard = card as? ActionCard {
            if !rhsBound.contains(actionCard.identifier) {
                rhsWillBind.insert(actionCard.identifier)
            }
        }
    })
    
    // make a new hand
    var hand = Hand()
    hand.addCards(from: lhs)
    hand.addCards(from: rhs)
    
    // bind them all together
    if let orCard = CardKit.Hand.Logic.LogicalOr.instance() as? LogicHandCard {
        orCard.children.appendContentsOf(lhsWillBind)
        orCard.children.appendContentsOf(rhsWillBind)
        hand.add(orCard)
    }
    
    return hand
}


//MARK: Adding Cards to a Hand

infix operator + { associativity left precedence 110 }

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
    var hand = Hand()
    hand.add(lhs)
    hand.add(rhs)
    return hand
}

public func + (lhs: Hand, rhs: ActionCardDescriptor) -> Hand {
    return lhs + rhs.instance()
}

public func + (lhs: Hand, rhs: ActionCard) -> Hand {
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


//MARK: Sequencing Hands

infix operator ==> { associativity left precedence 80 }

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


//MARK: Deckification

postfix operator % {}

public postfix func % (operand: [Hand]) -> Deck {
    var deck = Deck()
    deck.hands = operand
    return deck
}
