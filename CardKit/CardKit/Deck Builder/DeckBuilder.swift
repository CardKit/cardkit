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
    // create a NOT card bound to the operand
    var not = CKDescriptors.Hand.Logic.LogicalNot.instance()
    not.logic = .SatisfactionLogic(.LogicalNot(.Card(operand)))
    
    // create a new Hand
    var hand = Hand()
    hand.add(operand)
    hand.add(not)
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
    // create an AND card bound to the operands
    var andCard = CKDescriptors.Hand.Logic.LogicalAnd.instance()
    andCard.logic = .SatisfactionLogic(.LogicalAnd(.Card(lhs), .Card(rhs)))
    
    // create a new Hand
    var hand = Hand()
    hand.add(lhs)
    hand.add(rhs)
    hand.add(andCard)
    return hand
}

public func && (lhs: Hand, rhs: ActionCardDescriptor) -> Hand {
    return lhs && rhs.instance()
}

/// Return a new hand with the given ActionCard ANDed with the other cards in the hand. Note that the
/// logic for the new AND card will be appended to the logic of the last HandCard added to the hand.
/// Thus, a hand spec of "a && b && c" will have a logic of .And(.And(a, b), c), and a hand spec of
/// "a || b && c" will have a logic of .And(.Or(a, b), c).
public func && (lhs: Hand, rhs: ActionCard) -> Hand {
    // ANDing with a hand that has no cards just returns a hand with 1 card
    if lhs.count < 1 {
        var hand = Hand()
        hand.add(rhs)
        return hand
    }
    
    // get the logic from the last HandCard that has satisfcation logic
    let oldLogic: HandSatisfactionSpec? = lhs.lastHandSatisfactionSpec
    var newLogic: HandSatisfactionSpec? = nil
    
    // we have logic from a previous card
    if let oldLogic = oldLogic {
        // set the new logic to be the .And(<lastSpec>, .Card(rhs))
        newLogic = .LogicalAnd(oldLogic, .Card(rhs))
        
    } else {
        // there is no previous logic, so just .And(lastActionCard, rhs)
        if let lastActionCard = lhs.lastActionCard {
            newLogic = .LogicalAnd(.Card(lastActionCard), .Card(rhs))
            
        } else {
            // something is very weird, there is no action card, so lets AND
            // rhs with itself -- seems reasonable, no?
            newLogic = .LogicalAnd(.Card(rhs), .Card(rhs))
        }
    }
    
    if let newLogic = newLogic {
        var andCard = CKDescriptors.Hand.Logic.LogicalAnd.instance()
        andCard.logic = .SatisfactionLogic(newLogic)
        
        var hand = Hand()
        hand.addCards(from: lhs)
        hand.add(rhs)
        hand.add(andCard)
        return hand
    } else {
        // shouldn't happen
        return lhs
    }
}

public func && (lhs: Hand, rhs: HandCardDescriptor) -> Hand {
    return lhs && rhs.instance()
}

/// Return a new hand with the given HandCard appended to the Hand.
public func && (lhs: Hand, rhs: HandCard) -> Hand {
    var hand = Hand()
    hand.addCards(from: lhs)
    hand.add(rhs)
    return hand
}

/// Return a new hand by merging the two given hands
public func && (lhs: Hand, rhs: Hand) -> Hand {
    // add a new AND card with logic .And(lhs.oldLogic, rhs.oldLogic)
    let lhsOldLogic = lhs.lastHandSatisfactionSpec
    let rhsOldLogic = rhs.lastHandSatisfactionSpec
    
    var newLogic: HandSatisfactionSpec? = nil
    if let lhsOldLogic = lhsOldLogic {
        if let rhsOldLogic = rhsOldLogic {
            // both lhs and rhs have logic cards in them, AND them together
            newLogic = .LogicalAnd(lhsOldLogic, rhsOldLogic)
        } else {
            // only lhs has an existing logic card, create a new logic by ANDing everything in rhs with lhs
            var rhsNewLogic: HandSatisfactionSpec?
            
            if rhs.actionCards.count == 0 {
                rhsNewLogic = lhsOldLogic
            } else if rhs.actionCards.count == 1 {
                if let first = rhs.actionCards.first {
                    rhsNewLogic = .LogicalAnd(lhsOldLogic, .Card(first))
                }
            } else {
                if let first = rhs.actionCards.first {
                    rhsNewLogic = .Card(first)
                    for i in 1...rhs.actionCards.count {
                        let next = rhs.actionCards[i]
                        rhsNewLogic = .LogicalAnd(rhsNewLogic!, .Card(next))
                    }
                }
            }
            
            if let rhsNewLogic = rhsNewLogic {
                newLogic = .LogicalAnd(lhsOldLogic, rhsNewLogic)
            } else {
                newLogic = lhsOldLogic
            }
        }
    }
    
    // create the merged hand
    var hand = Hand()
    hand.addCards(from: lhs)
    hand.addCards(from: rhs)
    
    // create the AND card
    if let newLogic = newLogic {
        var andCard = CKDescriptors.Hand.Logic.LogicalAnd.instance()
        andCard.logic = .SatisfactionLogic(newLogic)
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
    // create an OR card bound to the operands
    var orCard = CKDescriptors.Hand.Logic.LogicalOr.instance()
    orCard.logic = .SatisfactionLogic(.LogicalOr(.Card(lhs), .Card(rhs)))
    
    // create a new Hand
    var hand = Hand()
    hand.add(lhs)
    hand.add(rhs)
    hand.add(orCard)
    return hand
}

public func || (lhs: Hand, rhs: ActionCardDescriptor) -> Hand {
    return lhs || rhs.instance()
}

/// Return a new hand with the given ActionCard ORed with the other cards in the hand. Note that the
/// logic for the new OR card will be appended to the logic of the last HandCard added to the hand.
/// Thus, a hand spec of "a || b || c" will have a logic of .Or(.Or(a, b), c), and a hand spec of
/// "a && b || c" will have a logic of .Or(.And(a, b), c).
public func || (lhs: Hand, rhs: ActionCard) -> Hand {
    // ORing with a hand that has no cards just returns a hand with 1 card
    if lhs.count < 1 {
        var hand = Hand()
        hand.add(rhs)
        return hand
    }
    
    // get the logic from the last HandCard that has satisfcation logic
    let oldLogic: HandSatisfactionSpec? = lhs.lastHandSatisfactionSpec
    var newLogic: HandSatisfactionSpec? = nil
    
    // we have logic from a previous card
    if let oldLogic = oldLogic {
        // set the new logic to be the .Or(<lastSpec>, .Card(rhs))
        newLogic = .LogicalOr(oldLogic, .Card(rhs))
        
    } else {
        // there is no previous logic, so just .Or(lastActionCard, rhs)
        if let lastActionCard = lhs.lastActionCard {
            newLogic = .LogicalOr(.Card(lastActionCard), .Card(rhs))
            
        } else {
            // something is very weird, there is no action card, so lets AND
            // rhs with itself -- seems reasonable, no?
            newLogic = .LogicalOr(.Card(rhs), .Card(rhs))
        }
    }
    
    if let newLogic = newLogic {
        var orCard = CKDescriptors.Hand.Logic.LogicalOr.instance()
        orCard.logic = .SatisfactionLogic(newLogic)
        
        var hand = Hand()
        hand.addCards(from: lhs)
        hand.add(rhs)
        hand.add(orCard)
        return hand
    } else {
        // shouldn't happen
        return lhs
    }
}

/// Return a new hand by merging the two given hands
public func || (lhs: Hand, rhs: Hand) -> Hand {
    // add a new OR card with logic .Or(lhs.oldLogic, rhs.oldLogic)
    let lhsOldLogic = lhs.lastHandSatisfactionSpec
    let rhsOldLogic = rhs.lastHandSatisfactionSpec
    
    var newLogic: HandSatisfactionSpec? = nil
    if let lhsOldLogic = lhsOldLogic {
        if let rhsOldLogic = rhsOldLogic {
            // both lhs and rhs have logic cards in them, OR them together
            newLogic = .LogicalOr(lhsOldLogic, rhsOldLogic)
        } else {
            // only lhs has an existing logic card, create a new logic by ANDing everything in rhs and then ORing it with lhs
            var rhsNewLogic: HandSatisfactionSpec?
            
            if rhs.actionCards.count == 0 {
                rhsNewLogic = lhsOldLogic
            } else if rhs.actionCards.count == 1 {
                if let first = rhs.actionCards.first {
                    rhsNewLogic = .LogicalAnd(lhsOldLogic, .Card(first))
                }
            } else {
                if let first = rhs.actionCards.first {
                    rhsNewLogic = .Card(first)
                    for i in 1...rhs.actionCards.count {
                        let next = rhs.actionCards[i]
                        rhsNewLogic = .LogicalAnd(rhsNewLogic!, .Card(next))
                    }
                }
            }
            
            if let rhsNewLogic = rhsNewLogic {
                newLogic = .LogicalOr(lhsOldLogic, rhsNewLogic)
            } else {
                newLogic = lhsOldLogic
            }
        }
    }
    
    // create the merged hand
    var hand = Hand()
    hand.addCards(from: lhs)
    hand.addCards(from: rhs)
    
    // create the OR card
    if let newLogic = newLogic {
        var orCard = CKDescriptors.Hand.Logic.LogicalAnd.instance()
        orCard.logic = .SatisfactionLogic(newLogic)
        hand.add(orCard)
    }
    
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
