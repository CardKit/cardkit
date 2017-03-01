//
//  DeckBuilder.swift
//  CardKit
//
//  Created by Justin Weisz on 8/3/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation


// MARK: Custom Operators

// Binding Input and Yields
precedencegroup BindingPrecedence {
    associativity: left
    higherThan: LogicalConjunctionPrecedence, CombiningPrecedence, SequencingPrecedence
}

infix operator <- : BindingPrecedence

precedencegroup CombiningPrecedence {
    associativity: left
    higherThan: SequencingPrecedence
}

infix operator ++ : CombiningPrecedence

// Sequencing Hands
precedencegroup SequencingPrecedence {
    associativity: right
    lowerThan: LogicalConjunctionPrecedence
}

infix operator ==> : SequencingPrecedence


// Sealing Hands into Decks
postfix operator %


// MARK: Binding Data to an InputCard

extension InputCardDescriptor {
    /// Bind data to an InputCardDescriptor. Creates a new
    /// InputCard instance first.
    public static func <-<T> (lhs: InputCardDescriptor, rhs: T) throws -> InputCard {
        return try lhs.makeCard() <- rhs
    }
}

extension InputCard {
    /// Bind data to an InputCard
    static func <-<T> (lhs: InputCard, rhs: T) throws -> InputCard {
        return try lhs.bound(withValue: rhs)
    }
}

// MARK: Binding Input & Token Cards to Action Cards

extension ActionCardDescriptor {
    /// Try binding an InputCard to an ActionCardDescriptor. Creates a new
    /// ActionCard instance first.
    public static func <- (lhs: ActionCardDescriptor, rhs: InputCard) throws -> ActionCard {
        return try lhs.makeCard() <- rhs
    }
    
    /// Try binding a set of InputCards to an ActionCardDescriptor. Creates a new
    /// ActionCard instance first.
    public static func <- (lhs: ActionCardDescriptor, rhs: [InputCard]) throws -> ActionCard {
        return try lhs.makeCard() <- rhs
    }
    
    /// Bind an InputCard to an ActionCardDescriptor in the given InputSlotName. Creates a new ActionCard
    /// instance first.
    public static func <- (lhs: ActionCardDescriptor, rhs: (InputSlotName, InputCard)) throws -> ActionCard {
        return try lhs.makeCard() <- rhs
    }
    
    /// Bind a TokenCard to an ActionCardDescriptor in the given TokenSlotName. Creates a new ActionCard
    /// instance first.
    public static func <- (lhs: ActionCardDescriptor, rhs: (TokenSlotName, TokenCard)) throws -> ActionCard {
        return try lhs.makeCard() <- rhs
    }
    
    /// Bind an ActionCardDescriptors's Yield to an ActionCardDescriptor. Creates new ActionCard
    /// instances first.
    public static func <- (lhs: ActionCardDescriptor, rhs: (ActionCardDescriptor, Yield)) throws -> ActionCard {
        return try lhs.makeCard() <- (rhs.0.makeCard(), rhs.1)
    }
    
    /// Bind an ActionCard's Yield to an ActionCardDescriptor. Creates a new ActionCard
    /// instance first.
    public static func <- (lhs: ActionCardDescriptor, rhs: (ActionCard, Yield)) throws -> ActionCard {
        return try lhs.makeCard() <- rhs
    }
}

extension ActionCard {
    /// Try binding an InputCard to an ActionCard, looking for the first
    /// available InputSlot that matches the InputCard's InputType
    static func <- (lhs: ActionCard, rhs: InputCard) throws -> ActionCard {
        return try lhs.bound(with: rhs)
    }
    
    /// Try binding a set of InputCards to an ActionCard.
    static func <- (lhs: ActionCard, rhs: [InputCard]) throws -> ActionCard {
        var ret = lhs
        for card in rhs {
            ret = try ret.bound(with: card)
        }
        return ret
    }

    /// Bind an InputCard to an ActionCard in the given InputSlotName
    public static func <- (lhs: ActionCard, rhs: (InputSlotName, InputCard)) throws -> ActionCard {
        return try lhs.bound(with: rhs.1, inSlotNamed: rhs.0)
    }
    
    /// Bind an array of InputCards to an ActionCard in the given InputSlotName
    public static func <- (lhs: ActionCard, rhs: [(InputSlotName, InputCard)]) throws -> ActionCard {
        var ret = lhs
        for tuple in rhs {
            ret = try ret.bound(with: tuple.1, inSlotNamed: tuple.0)
        }
        return ret
    }
    
    
    /// Bind a TokenCard to an ActionCard in the given TokenSlotName
    public static func <- (lhs: ActionCard, rhs: (TokenSlotName, TokenCard)) throws -> ActionCard {
        return try lhs.bound(with: rhs.1, inSlotNamed: rhs.0)
    }
    
    /// Bind an array of TokenCards to an ActionCard in the given TokenSlotName
    public static func <- (lhs: ActionCard, rhs: [(TokenSlotName, TokenCard)]) throws -> ActionCard {
        var ret = lhs
        for tuple in rhs {
            ret = try ret.bound(with: tuple.1, inSlotNamed: tuple.0)
        }
        return ret
    }
    
    /// Bind an ActionCardDescriptor's Yield to an ActionCard. Creates a new ActionCard
    /// instance first.
    public static func <- (lhs: ActionCard, rhs: (ActionCardDescriptor, Yield)) throws -> ActionCard {
        return try lhs <- (rhs.0.makeCard(), rhs.1)
    }

    /// Bind a Yield to an ActionCard.
    static func <- (lhs: ActionCard, rhs: (ActionCard, Yield)) throws -> ActionCard {
        return try lhs.bound(with: rhs.0, yield: rhs.1)
    }
}


// MARK: Not Operation

extension ActionCardDescriptor {
    /// Return a new hand with the given ActionCard and a Not card played with it
    public static prefix func ! (operand: ActionCardDescriptor) -> Hand {
        return !operand.makeCard()
    }
}

extension ActionCard {
    /// Return a new hand with the given ActionCard and a Not card played with it
    public static prefix func ! (operand: ActionCard) -> Hand {
        // create a new Hand
        let hand = Hand()
        
        // create a NOT card bound to the operand
        if let notCard: LogicHandCard = CardKit.Hand.Logic.LogicalNot.typedInstance() {
            hand.attach(operand, to: notCard)
        }
        
        return hand
    }
}


// MARK: And Operations

extension ActionCardDescriptor {
    public static func && (lhs: ActionCardDescriptor, rhs: ActionCardDescriptor) -> Hand {
        return lhs.makeCard() && rhs.makeCard()
    }

    public static func && (lhs: ActionCardDescriptor, rhs: ActionCard) -> Hand {
        return lhs.makeCard() && rhs
    }
    
    public static func && (lhs: ActionCardDescriptor, rhs: Hand) -> Hand {
        return lhs.makeCard() && rhs
    }
}

extension ActionCard {
    public static func && (lhs: ActionCard, rhs: ActionCardDescriptor) -> Hand {
        return lhs && rhs.makeCard()
    }

    /// Return a new hand with the given ActionCards ANDed together
    public static func && (lhs: ActionCard, rhs: ActionCard) -> Hand {
        // create a new Hand
        let hand = Hand()
        
        // create an AND card bound to the operands
        if let andCard: LogicHandCard = CardKit.Hand.Logic.LogicalAnd.typedInstance() {
            hand.attach(lhs, to: andCard)
            hand.attach(rhs, to: andCard)
        }
        
        return hand
    }
    
    public static func && (lhs: ActionCard, rhs: Hand) -> Hand {
        let hand = Hand()
        hand.add(lhs)
        return rhs && hand
    }
}

extension Hand {
    public static func && (lhs: Hand, rhs: ActionCardDescriptor) -> Hand {
        return lhs && rhs.makeCard()
    }

    public static func && (lhs: Hand, rhs: ActionCard) -> Hand {
        let hand = Hand()
        hand.add(rhs)
        return lhs && hand
    }
    
    /// Returns a new hand with the given hands combined together using AND logic. This works by
    /// collapsing all CardTrees in each hand using the logical operator specified by the End Rule
    /// (AND for EndWhenAllSatisfied, OR for EndWhenAnySatisfied), and then ANDing the singular-
    /// trees in lhs and rhs. Branch cards are removed in this operation because the CardTrees are no
    /// longer valid. All other cards (Hand, Repeat, End Rule) are copied into the
    /// new Hand, with rhs having precedence when there are conflicts.
    public static func && (lhs: Hand, rhs: Hand) -> Hand {
        return lhs.collapsed(combiningWith: rhs, usingLogicalOperation: .booleanAnd)
    }
}


// MARK: Or Operations

extension ActionCardDescriptor {
    public static func || (lhs: ActionCardDescriptor, rhs: ActionCardDescriptor) -> Hand {
        return lhs.makeCard() || rhs.makeCard()
    }

    public static func || (lhs: ActionCardDescriptor, rhs: ActionCard) -> Hand {
        return lhs.makeCard() || rhs
    }
    
    public static func || (lhs: ActionCardDescriptor, rhs: Hand) -> Hand {
        return lhs.makeCard() || rhs
    }
}

extension ActionCard {
    public static func || (lhs: ActionCard, rhs: ActionCardDescriptor) -> Hand {
        return lhs || rhs.makeCard()
    }

    /// Return a new hand with the given ActionCards ORed together
    public static func || (lhs: ActionCard, rhs: ActionCard) -> Hand {
        // create a new Hand
        let hand = Hand()
        hand.add(lhs)
        hand.add(rhs)
        
        // create an OR card bound to the operands
        if let orCard: LogicHandCard = CardKit.Hand.Logic.LogicalOr.typedInstance() {
            hand.attach(lhs, to: orCard)
            hand.attach(rhs, to: orCard)
        }
        
        return hand
    }
    
    public static func || (lhs: ActionCard, rhs: Hand) -> Hand {
        let hand = Hand()
        hand.add(lhs)
        return rhs || hand
    }
}

extension Hand {
    public static func || (lhs: Hand, rhs: ActionCardDescriptor) -> Hand {
        return lhs || rhs.makeCard()
    }

    public static func || (lhs: Hand, rhs: ActionCard) -> Hand {
        let hand = Hand()
        hand.add(rhs)
        return lhs || hand
    }
    
    /// Returns a new hand with the given hands combined together using OR logic. This works by
    /// collapsing all CardTrees in each hand using the logical operator specified by the End Rule
    /// (AND for EndWhenAllSatisfied, OR for EndWhenAnySatisfied), and then ORing the singular-
    /// trees in lhs and rhs. Branch cards are removed in this operation because the CardTrees are no
    /// longer valid. All other cards (Hand, Repeat, End Rule) are copied into the
    /// new Hand, with rhs having precedence when there are conflicts.
    public static func || (lhs: Hand, rhs: Hand) -> Hand {
        return lhs.collapsed(combiningWith: rhs, usingLogicalOperation: .booleanOr)
    }
}


// MARK: Adding Cards to a Hand

extension ActionCardDescriptor {
    public static func ++ (lhs: ActionCardDescriptor, rhs: ActionCardDescriptor) -> Hand {
        return lhs.makeCard() ++ rhs.makeCard()
    }

    public static func ++ (lhs: ActionCardDescriptor, rhs: ActionCard) -> Hand {
        return lhs.makeCard() ++ rhs
    }
}

extension ActionCard {
    public static func ++ (lhs: ActionCard, rhs: ActionCardDescriptor) -> Hand {
        return lhs ++ rhs.makeCard()
    }

    public static func ++ (lhs: ActionCard, rhs: ActionCard) -> Hand {
        let hand = Hand()
        hand.add(lhs)
        hand.add(rhs)
        return hand
    }
}

extension HandCardDescriptor {
    public static func ++ (lhs: HandCardDescriptor, rhs: HandCardDescriptor) -> Hand {
        return lhs.makeCard() ++ rhs.makeCard()
    }
    
    public static func ++ (lhs: HandCardDescriptor, rhs: HandCard) -> Hand {
        return lhs.makeCard() ++ rhs
    }
}

extension HandCard {
    public static func ++ (lhs: HandCard, rhs: HandCardDescriptor) -> Hand {
        return lhs ++ rhs.makeCard()
    }
    
    public static func ++ (lhs: HandCard, rhs: HandCard) -> Hand {
        let hand = Hand()
        hand.add(lhs)
        hand.add(rhs)
        return hand
    }
}

extension Hand {
    public static func ++ (lhs: Hand, rhs: ActionCardDescriptor) -> Hand {
        return lhs ++ rhs.makeCard()
    }

    public static func ++ (lhs: Hand, rhs: ActionCard) -> Hand {
        let hand = lhs
        hand.add(rhs)
        return hand
    }
    
    public static func ++ (lhs: Hand, rhs: HandCardDescriptor) -> Hand {
        return lhs ++ rhs.makeCard()
    }
    
    public static func ++ (lhs: Hand, rhs: HandCard) -> Hand {
        let hand = lhs
        hand.add(rhs)
        return hand
    }
}


// MARK: Merging Hands Together

extension Hand {
    public static func ++ (lhs: Hand, rhs: Hand) -> Hand {
        return lhs.merged(with: rhs)
    }
}


// MARK: Sequencing Hands

extension ActionCardDescriptor {
    public static func ==> (lhs: ActionCardDescriptor, rhs: ActionCardDescriptor) -> [Hand] {
        return lhs.makeCard() ==> rhs.makeCard()
    }

    public static func ==> (lhs: ActionCardDescriptor, rhs: ActionCard) -> [Hand] {
        return lhs.makeCard() ==> rhs
    }
    
    public static func ==> (lhs: ActionCardDescriptor, rhs: Hand) -> [Hand] {
        return lhs.makeCard() ==> rhs
    }
    
    public static func ==> (lhs: ActionCardDescriptor, rhs: [Hand]) -> [Hand] {
        return lhs.makeCard() ==> rhs
    }
}

extension ActionCard {
    public static func ==> (lhs: ActionCard, rhs: ActionCardDescriptor) -> [Hand] {
        return lhs ==> rhs.makeCard()
    }

    /// Return a new deck with lhs and rhs as separate hands
    public static func ==> (lhs: ActionCard, rhs: ActionCard) -> [Hand] {
        let lhsHand = Hand()
        lhsHand.add(lhs)
        let rhsHand = Hand()
        rhsHand.add(rhs)
        return [lhsHand, rhsHand]
    }
    
    public static func ==> (lhs: ActionCard, rhs: Hand) -> [Hand] {
        let lhsHand = Hand()
        lhsHand.add(lhs)
        return [lhsHand, rhs]
    }
    
    public static func ==> (lhs: ActionCard, rhs: [Hand]) -> [Hand] {
        let hand = Hand()
        hand.add(lhs)
        
        var hands: [Hand] = []
        hands.append(hand)
        hands.append(contentsOf: rhs)
        return hands
    }
}

extension HandCardDescriptor {
    public static func ==> (lhs: HandCardDescriptor, rhs: [Hand]) -> [Hand] {
        return lhs.makeCard() ==> rhs
    }
}

extension HandCard {
    public static func ==> (lhs: HandCard, rhs: [Hand]) -> [Hand] {
        let hand = Hand()
        hand.add(lhs)
        
        var hands: [Hand] = []
        hands.append(hand)
        hands.append(contentsOf: rhs)
        return hands
    }
}

extension Hand {
    public static func ==> (lhs: Hand, rhs: ActionCardDescriptor) -> [Hand] {
        return lhs ==> rhs.makeCard()
    }
    
    public static func ==> (lhs: Hand, rhs: ActionCard) -> [Hand] {
        let rhsHand = Hand()
        rhsHand.add(rhs)
        return [lhs, rhsHand]
    }
    
    public static func ==> (lhs: Hand, rhs: Hand) -> [Hand] {
        return [lhs, rhs]
    }
}


// MARK: Sealing Hands & Decks

extension ActionCard {
    /// Seals a card into a Hand
    public static postfix func % (operand: ActionCard) -> Hand {
        let hand = Hand()
        hand.add(operand)
        return hand
    }
}

extension Array where Iterator.Element : ActionCard {
    /// Seals a set of cards into an hand
    public static postfix func % (operand: [ActionCard]) -> Hand {
        let hand = Hand()
        hand.add(operand)
        return hand
    }
}

extension HandCard {
    /// Seals a card into a Hand
    public static postfix func % (operand: HandCard) -> Hand {
        let hand = Hand()
        hand.add(operand)
        return hand
    }
}

extension Hand {
    /// Seals a deck with a given Hand
    public static postfix func % (operand: Hand) -> Deck {
        return [operand]%
    }
}

extension Array where Iterator.Element : Hand {
    /// Seals a deck with the given set of hands
    public static postfix func % (operand: [Hand]) -> Deck {
        let deck = Deck()
        deck.deckHands = operand
        return deck
    }
}

// MARK: Adding Cards to a Deck

extension Deck {
    /// Adds a TokenCard to a Deck
    public static func + (lhs: Deck, rhs: TokenCard) -> Deck {
        let deck = Deck(copying: lhs)
        deck.add(rhs)
        return deck
    }
    
    /// Adds an instance of DeckCardDescriptor to a Deck
    public static func + (lhs: Deck, rhs: DeckCardDescriptor) -> Deck {
        let deck = Deck(copying: lhs)
        deck.add(rhs.makeCard())
        return deck
    }

    /// Adds a DeckCard to a Deck
    public static func + (lhs: Deck, rhs: DeckCard) -> Deck {
        let deck = Deck(copying: lhs)
        deck.add(rhs)
        return deck
    }
}
