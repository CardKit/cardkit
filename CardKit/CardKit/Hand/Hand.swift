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
    /// A Hand is a forest of CardTrees. Each CardTree encapsulates a set of
    /// LogicHandCards and ActionCards. A CardTree may be associated with a BranchHandCard
    /// in the case that upon satisfaction of the CardTree's logic, execution branches
    /// to the target of the BranchHandCard.
    private var cardTrees: [CardTree] = []
    
    /// These are the Hands to which we may branch.
    private var childHands: [HandIdentifier : Hand] = [:]
    
    /// These cards specify which CardTree branches to which child Hand.
    private var branchCards: [BranchHandCard] = []
    
    /// Specifies the End Rule that governs the logic of this Hand. The default
    /// is that ALL cards in the hand must End before moving to the next Hand.
    /// There may only be one EndRuleCard in a Hand.
    private var endRuleCard: EndRuleHandCard = EndRuleHandCard(with: CardKit.Hand.End.All)
    
    /// Specifies whether the hand should repeat a number of times
    private var repeatCard: RepeatHandCard? = nil
    
    /// Unique identifier for the Hand
    public var identifier: HandIdentifier = HandIdentifier()
    
    /// Returns all of the Cards in the hand, including ActionCards (with their bound InputCards),
    /// BranchHandCards, LogicHandCards, and the EndRuleHandCard.
    public var cards: [Card] {
        var cards: [Card] = []
        
        // append all cards in all cardTrees
        cardTrees.forEach { cards.appendContentsOf($0.cards) }
        
        // append all branch cards
        branchCards.forEach { cards.append($0) }
        
        // append the end rule card
        cards.append(self.endRuleCard)
        
        return cards
    }
    
    /// The number of cards in a hand includes all Action and Hand
    /// cards added to the hand, plus any Input or Token cards that
    /// are bound to the Action cards.
    public var cardCount: Int {
        return self.cards.count
    }
    
    /// Determines how the hand will end: when ALL cards have been satisfied, or
    /// when ANY card has been satisfied. By default, hands will end when ALL cards have
    /// been satisfied.
    public var endRule: HandEndRule {
        return self.endRuleCard.endRule
    }
    
    /// Return the set of sub-Hands to which this Hand may branch.
    public var subhands: [Hand] {
        return Array(self.childHands.values)
    }
}

//MARK: Card Addition

extension Hand {
    /// Add the card to the hand if it isn't in the hand already.
    mutating func add(card: ActionCard) {
        if !self.contains(card) {
            // make a new CardTree with the card
            self.cardTrees.append(.Action(card))
        }
    }
    
    /// Add the given cards to the hand, ignoring cards that have already
    /// been added to the hand.
    mutating func add(cards: [ActionCard]) {
        cards.forEach { self.add($0) }
    }
    
    /// Add the HandCard to the hand if it isn't in the hand already.
    mutating func add(card: HandCard) {
        if !self.contains(card) {
            // figure out what this is to know where to add it
            switch card.descriptor.handCardType {
            case .BooleanLogicAnd, .BooleanLogicOr:
                guard let logicCard = card as? LogicHandCard else { return }
                self.cardTrees.append(.BinaryLogic(logicCard, nil, nil))
            case .BooleanLogicNot:
                guard let logicCard = card as? LogicHandCard else { return }
                self.cardTrees.append(.UnaryLogic(logicCard, nil))
            case .Branch:
                guard let branchCard = card as? BranchHandCard else { return }
                self.branchCards.append(branchCard)
            case .EndWhenAllSatisfied, .EndWhenAnySatisfied:
                guard let endCard = card as? EndRuleHandCard else { return }
                self.endRuleCard = endCard
            case .Repeat:
                guard let repeatCard = card as? RepeatHandCard else { return }
                self.repeatCard = repeatCard
            }
        }
    }
    
    /// Add the given cards to the hand, ignoring cards that have already
    /// been added to the hand.
    mutating func add(cards: [HandCard]) {
        cards.forEach { self.add($0) }
    }
}

//MARK: Card Removal

extension Hand {
    /// Remove the given card from the hand.
    mutating func remove(card: ActionCard) {
        // remove the card from the CardTree in which it lives
        var newTrees: [CardTree] = []
        for tree in self.cardTrees {
            if let newTree = tree.cardTree(removing: card) {
                newTrees.append(newTree)
            }
        }
    }
    
    /// Remove the given cards from the hand.
    mutating func remove(cards: [ActionCard]) {
        cards.forEach { self.remove($0) }
    }
    
    /// Remove the given card from the hand. Note that EndRule cards with the rule
    /// EndWhenAllSatisfied cannot be removed as this is the default.
    mutating func remove(card: HandCard) {
        // figure out what this is to know how to remove it
        switch card.descriptor.handCardType {
        case .BooleanLogicAnd, .BooleanLogicOr, .BooleanLogicNot:
            guard let logicCard = card as? LogicHandCard else { return }
            
            // remove the card from the CardTree in which it lives
            if let tree = self.cardTrees.cardTree(containing: logicCard) {
                let (newTree, orphans) = tree.cardTree(removing: logicCard)
                if let stillATreeLeft = newTree {
                    self.cardTrees.append(stillATreeLeft)
                }
                self.cardTrees.appendContentsOf(orphans)
            }
            
        case .Branch:
            guard let branchCard = card as? BranchHandCard else { return }
            self.branchCards.removeObject(branchCard)
            
        case .EndWhenAllSatisfied:
            // cannot remove. mwahaha.
            return
            
        case .EndWhenAnySatisfied:
            // make sure we're trying to remove *this* EndRuleHandCard
            if self.endRuleCard.identifier == card.identifier {
                // revert to EndWhenAllSatisfied
                self.endRuleCard = EndRuleHandCard(with: CardKit.Hand.End.All)
            }
            
        case .Repeat:
            // make sure we're trying to remove *this* RepeatHandCard
            if self.repeatCard?.identifier == card.identifier {
                self.repeatCard = nil
            }
        }
    }
    
    /// Remove the given cards from the hand.
    mutating func remove(cards: [HandCard]) {
        cards.forEach { self.remove($0) }
    }
    
    /// Remove all cards from the hand. Does not remove the End Rule card, or any 
    /// cards in child Hands.
    mutating func removeAll() {
        self.cardTrees.removeAll()
        self.branchCards.removeAll()
        self.repeatCard = nil
    }
}

//MARK: Card Query

extension Hand {
    /// Returns true if the hand contains the given card.
    func contains(card: ActionCard) -> Bool {
        return self.cardTrees.reduce(false) {
            return $0 || $1.contains(cardIdentifier: card.identifier)
        }
    }
    
    /// Returns true if the hand contains the given card.
    func contains(card: HandCard) -> Bool {
        // figure out what this is to know how to remove it
        switch card.descriptor.handCardType {
        case .BooleanLogicAnd, .BooleanLogicOr, .BooleanLogicNot:
            return self.cardTrees.reduce(false) {
                return $0 || $1.contains(cardIdentifier: card.identifier)
            }
            
        case .Branch:
            guard let branchCard = card as? BranchHandCard else { return false }
            return self.branchCards.contains(branchCard)
            
        case .EndWhenAllSatisfied, .EndWhenAnySatisfied:
            guard let endRuleCard = card as? EndRuleHandCard else { return false }
            return endRuleCard == self.endRuleCard
            
        case .Repeat:
            guard let repeatCard = card as? RepeatHandCard else { return false }
            return repeatCard == self.repeatCard
        }
    }
    
    /// Returns the set of ActionCards with the given descriptor.
    func cards(matching descriptor: ActionCardDescriptor) -> [ActionCard] {
        var matching: [ActionCard] = []
        for tree in self.cardTrees {
            matching.appendContentsOf(tree.cards(matching: descriptor))
        }
        return matching
    }
    
    /// Returns the set of HandCards with the given descriptor.
    func cards(matching descriptor: HandCardDescriptor) -> [HandCard] {
        switch descriptor.handCardType {
        case .BooleanLogicAnd, .BooleanLogicOr, .BooleanLogicNot:
            // find all LogicHandCards in the CardTrees
            var matching: [HandCard] = []
            for tree in self.cardTrees {
                matching.appendContentsOf(tree.cards(matching: descriptor).map { $0 as HandCard })
            }
            return matching
            
        case .Branch:
            return self.branchCards.filter { $0.descriptor == descriptor }
        
        case .EndWhenAllSatisfied, .EndWhenAnySatisfied:
            if self.endRuleCard.descriptor == descriptor {
                return [self.endRuleCard]
            } else {
                return []
            }
            
        case .Repeat:
            if let repeatCard = self.repeatCard {
                if repeatCard.descriptor == descriptor {
                    return [repeatCard]
                }
            }
            
            return []
        }
    }
    
    /// Returns the Card matching the given CardIdentifier
    func card(with identifier: CardIdentifier) -> Card? {
        // is this the End Rule card?
        if self.endRuleCard.identifier == identifier {
            return self.endRuleCard
        }
        
        // is this the Repeat card?
        if self.repeatCard?.identifier == identifier {
            return self.repeatCard
        }
        
        // is this a Branch card?
        for branchCard in self.branchCards {
            if branchCard.identifier == identifier {
                return branchCard
            }
        }
        
        // try to find this card in the CardTrees
        if let card = self.cardTrees.card(with: identifier) {
            return card
        }
        
        // not found
        return nil
    }
}

//MARK: CardTree Manipulation

extension Hand {
    /// Attaches an ActionCard to nest under a LogicHandCard. Fails if the destination
    /// already has its child slots filled.
    public mutating func attach(card: ActionCard, to destination: LogicHandCard) {
        // get the root of the tree containing destination
        guard let root = self.cardTrees.cardTree(containing: destination) else { return }
        
        // remove the old tree
        self.cardTrees.removeObject(root)
        
        // create a new tree with the card attached in the right place
        var newTree: CardTree? = nil
        
        // card is already present in the tree?
        if let orphanTree = self.detach(card) {
            newTree = root.attached(with: orphanTree, asChildOf: destination)
        } else {
            newTree = root.attached(with: .Action(card), asChildOf: destination)
        }
        
        if let newTree = newTree {
            self.cardTrees.append(newTree)
        }
    }
    
    /// Attaches a LogicHandCard to nest under another LogicHandCard. Fails if the destination
    /// already has its child slots filled.
    public mutating func attach(card: LogicHandCard, to destination: LogicHandCard) {
        // get the root of the tree containing destination
        guard let root = self.cardTrees.cardTree(containing: destination) else { return }
        
        // remove the old tree
        self.cardTrees.removeObject(root)
        
        // create a new tree with the card attached in the right place
        var newTree: CardTree? = nil
        
        // card is already present in the tree?
        if let orphanTree = self.detach(card) {
            newTree = root.attached(with: orphanTree, asChildOf: destination)
        } else {
            switch card.operation {
            case .BooleanAnd, .BooleanOr:
                newTree = .BinaryLogic(card, nil, nil)
            case .BooleanNot:
                newTree = .UnaryLogic(card, nil)
            case .Indeterminate:
                newTree = nil
            }
        }
        
        if let newTree = newTree {
            self.cardTrees.append(newTree)
        }
    }
    
    /// Detaches an ActionCard from its parent. Returns the detached CardTree node.
    public mutating func detach(card: ActionCard) -> CardTree? {
        // get the root of the tree containing the card
        guard let root = self.cardTrees.cardTree(containing: card) else { return nil }
        
        // remove the old root from the forest
        self.cardTrees.removeObject(root)
        
        // get the new tree without the card and add it to the forest
        if let newRoot = root.cardTree(removing: card) {
            self.cardTrees.append(newRoot)
        }
        
        // return the detached ActionCard
        return .Action(card)
    }
    
    /// Detaches a LogicHandCard from its parent. Returns the detached CardTree node.
    public mutating func detach(card: LogicHandCard) -> CardTree? {
        // get the root of the tree containing the card
        guard let root = self.cardTrees.cardTree(containing: card) else { return nil }
        
        // remove the old root from the forest
        self.cardTrees.removeObject(root)
        
        // get the new tree without the card and add it to the forest
        var detached: CardTree? = nil
        let (newRoot, orphans) = root.cardTree(removing: card)
        if let reallyANewRoot = newRoot {
            self.cardTrees.append(reallyANewRoot)
        }
        
        // (re-)create the node that was detached
        switch card.operation {
        case .BooleanAnd, .BooleanOr:
            // expecting up to 2 children
            let left: CardTree? = orphans.count > 0 ? orphans[0] : nil
            let right: CardTree? = orphans.count > 1 ? orphans[1] : nil
            detached = .BinaryLogic(card, left, right)
            
        case .BooleanNot:
            // expecting up to 1 child
            let subtree: CardTree? = orphans.count > 0 ? orphans[0] : nil
            detached = .UnaryLogic(card, subtree)
            
        case .Indeterminate:
            // not sure how we got an Indeterminate
            detached = nil
        }
        
        return detached
    }
}

//MARK: Hand Merging

extension Hand {
    /// Merges the two hands together. If there are conflicting EndRules, the one
    /// that takes precedence is the one from the hand being merged into this one.
    mutating func merge(with hand: Hand) {
        // copy in all of the CardTrees
        self.cardTrees.appendContentsOf(hand.cardTrees)
        
        // copy in all of the child hands -- if there are any conflicts, the
        // hand being merged in will win
        for (identifier, hand) in hand.childHands {
            self.childHands[identifier] = hand
        }
        
        // copy in any Branch cards
        self.branchCards.appendContentsOf(hand.branchCards)
        
        // copy the End Rule card
        self.endRuleCard = hand.endRuleCard
        
        // copy the Repeat card
        self.repeatCard = hand.repeatCard
    }
    
    /// Returns a new hand merged with the given hand.
    func merged(with hand: Hand) -> Hand {
        var merged: Hand = Hand()
        
        // copy in the CardTrees
        self.cardTrees.forEach { merged.cardTrees.append($0) }
        hand.cardTrees.forEach { merged.cardTrees.append($0) }
        
        // copy in the child Hands
        self.subhands.forEach { merged.childHands[$0.identifier] = $0 }
        hand.subhands.forEach { merged.childHands[$0.identifier] = $0 }
        
        // use the EndRule card from the hand being merged in
        merged.endRuleCard = hand.endRuleCard
        
        // prefer the Repeat card from the hand being merged in
        merged.repeatCard = hand.repeatCard ?? self.repeatCard
        
        return merged
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

//MARK: JSONEncodable

extension Hand: JSONEncodable {
    public func toJSON() -> JSON {
        return .Dictionary([
            "cardTrees": self.cardTrees.toJSON(),
            "childHands": self.childHands.toJSON(),
            "branchCards": self.branchCards.toJSON(),
            "repeatCard": self.repeatCard?.toJSON() ?? .String("nil"),
            "endRuleCard": self.endRuleCard.toJSON(),
            "identifier": self.identifier.toJSON()
            ])
    }
}

//MARK: JSONDecodable

extension Hand: JSONDecodable {
    public init(json: JSON) throws {
        self.cardTrees = try json.arrayOf("cardTrees", type: CardTree.self)
        self.childHands = try json.dictionary("childHands").withDecodedKeysAndValues()
        self.branchCards = try json.arrayOf("branchCards", type: BranchHandCard.self)
        self.endRuleCard = try json.decode("endRuleCard", type: EndRuleHandCard.self)
        self.identifier = try json.decode("identifier", type: HandIdentifier.self)
        
        let repeatStr = try json.string("repeatCard")
        if repeatStr == "nil" {
            self.repeatCard = nil
        } else {
            self.repeatCard = try json.decode("repeatCard", type: RepeatHandCard.self)
        }
    }
}
