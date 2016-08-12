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
    private (set) var cardTrees: [CardTree] = []
    
    /// The set of Hands to which this Hand may branch.
    private (set) var subhands: [Hand] = []
    
    /// These cards specify which CardTree branches to which child Hand.
    private (set) var branchCards: [BranchHandCard] = []
    
    /// Specifies whether the hand should repeat a number of times
    private (set) var repeatCard: RepeatHandCard? = nil
    
    /// Specifies the End Rule that governs the logic of this Hand. The default
    /// is that ALL cards in the hand must End before moving to the next Hand.
    /// There may only be one EndRuleCard in a Hand.
    private (set) var endRuleCard: EndRuleHandCard = EndRuleHandCard(with: CardKit.Hand.End.All)
    
    /// Unique identifier for the Hand
    public var identifier: HandIdentifier = HandIdentifier()
    
    /// Returns all of the Cards in the hand, including ActionCards (with their bound InputCards),
    /// BranchHandCards, LogicHandCards, and the EndRuleHandCard.
    public var cards: [Card] {
        var cards: [Card] = []
        
        // append all cards in all cardTrees
        self.cardTrees.forEach { cards.appendContentsOf($0.cards) }
        
        // append all branch cards
        self.branchCards.forEach { cards.append($0) }
        
        // appeand the repeat card
        if let repeatCard = self.repeatCard {
            cards.append(repeatCard)
        }
        
        // append the end rule card
        cards.append(self.endRuleCard)
        
        return cards
    }
    
    /// The number of cards in a hand includes all Action and Hand
    /// cards added to the hand, plus any Input or Token cards that
    /// are bound to the Action cards. Note that cardCount will be 1 
    /// for "empty" hands because the End Rule card is always present in
    /// a hand.
    public var cardCount: Int {
        return self.cards.count
    }
    
    /// Determines how the hand will end: when ALL cards have been satisfied, or
    /// when ANY card has been satisfied. By default, hands will end when ALL cards have
    /// been satisfied.
    public var endRule: HandEndRule {
        return self.endRuleCard.endRule
    }
    
    /// The number of times to repeat execution of the hand, based on the presence of a Repeat card.
    /// Hands not containing a Repeat card will execute only once.
    public var repeatCount: Int {
        return self.repeatCard?.repeatCount ?? 0
    }
    
    /// The number of times the hand will be executed. This is always one greater than the
    /// repeatCount of any Repeat cards present in the hand. The default execution count is 1.
    public var executionCount: Int {
        return self.repeatCount + 1
    }
}

//MARK: Card Addition

extension Hand {
    /// Add the card to the hand if it isn't in the hand already.
    mutating func add(card: ActionCard) {
        if !self.contains(card) {
            // make a new CardTree with the card
            var tree = CardTree()
            tree.root = .Action(card)
            self.cardTrees.append(tree)
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
                var tree = CardTree()
                tree.root = .BinaryLogic(logicCard, nil, nil)
                self.cardTrees.append(tree)
            case .BooleanLogicNot:
                guard let logicCard = card as? LogicHandCard else { return }
                var tree = CardTree()
                tree.root = .UnaryLogic(logicCard, nil)
                self.cardTrees.append(tree)
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
        if var tree = self.cardTrees.cardTree(containing: card) {
            tree.remove(card)
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
            if var tree = self.cardTrees.cardTree(containing: logicCard) {
                let orphans = tree.remove(logicCard)
                
                // add in any orphaned CardTrees
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
    
    /// Returns the CardIdentifiers of the child cards of the given LogicHandCard.
    func children(of card: LogicHandCard) -> [CardIdentifier] {
        
        func cardIdentifierFromNode(node: CardTreeNode) -> CardIdentifier {
            switch node {
            case .Action(let child):
                return child.identifier
            case .UnaryLogic(let child, _):
                return child.identifier
            case .BinaryLogic(let child, _, _):
                return child.identifier
            }
        }
        
        guard let node = self.cardTrees.cardTreeNode(of: card) else { return [] }
        
        var children: [CardIdentifier] = []
        
        if case .UnaryLogic(_, let subtree) = node {
            // pull out the child CardIdentifier from the subtree node
            if let subtree = subtree {
                children.append(cardIdentifierFromNode(subtree))
            }
            
        } else if case .BinaryLogic(_, let left, let right) = node {
            // pull out the child CardIdentifier from each subtree
            if let left = left {
                children.append(cardIdentifierFromNode(left))
            }
            if let right = right {
                children.append(cardIdentifierFromNode(right))
            }
        }
        
        return children
    }
}

//MARK: CardTree Manipulation

extension Hand {
    /// Attaches an ActionCard to nest under a LogicHandCard. Fails if the destination
    /// already has its child slots filled.
    public mutating func attach(card: ActionCard, to destination: LogicHandCard) {
        // get the tree containing destination, or create a new tree if the logic card isn't in the hand yet
        guard var destinationTree: CardTree = self.cardTrees.cardTree(containing: destination) ?? destination.asCardTree() else { return }
        
        // detach the ActionCard from the tree it is in,
        if let orphan = self.detach(card) {
            destinationTree.attach(with: orphan, asChildOf: destination)
        } else {
            // card wasn't previously attached to anything, so just attach it
            destinationTree.attach(with: card, asChildOf: destination)
        }
    }
    
    /// Attaches a LogicHandCard to nest under another LogicHandCard. Fails if the destination
    /// already has its child slots filled.
    public mutating func attach(card: LogicHandCard, to destination: LogicHandCard) {
        // get the tree containing destination, or create a new tree if the logic card isn't in the hand yet
        guard var destinationTree: CardTree = self.cardTrees.cardTree(containing: destination) ?? destination.asCardTree() else { return }
        
        // detach the LogicHandCard from the tree it is in
        if let orphan = self.detach(card) {
            destinationTree.attach(with: orphan, asChildOf: destination)
        } else {
            // card wasn't previously attached to anything, so just attach it
            destinationTree.attach(with: card, asChildOf: destination)
        }
    }
    
    /// Detaches an ActionCard from its parent. Returns the detached CardTreeNode, or nil if the 
    /// ActionCard wasn't found in the Hand.
    public mutating func detach(card: ActionCard) -> CardTreeNode? {
        guard var tree = self.cardTrees.cardTree(containing: card) else { return nil }
        tree.remove(card)
        return .Action(card)
    }
    
    /// Detaches a LogicHandCard from its parent. Returns the detached CardTreeNode, or nil
    /// if the LogicHandCard wasn't found in the Hand.
    public mutating func detach(card: LogicHandCard) -> CardTreeNode? {
        guard var tree = self.cardTrees.cardTree(containing: card) else { return nil }
        let orphans = tree.remove(card)
        
        // (re-)create the node that was removed with the orphans attached
        var detached: CardTreeNode? = nil
        
        switch card.operation {
        case .BooleanAnd, .BooleanOr:
            // expecting up to 2 children
            let left: CardTreeNode? = orphans.count > 0 ? orphans[0].root : nil
            let right: CardTreeNode? = orphans.count > 1 ? orphans[1].root : nil
            detached = .BinaryLogic(card, left, right)
            
        case .BooleanNot:
            // expecting up to 1 child
            let subtree: CardTreeNode? = orphans.count > 0 ? orphans[0].root : nil
            detached = .UnaryLogic(card, subtree)
            
        case .Indeterminate:
            // not sure how we got an Indeterminate
            detached = nil
        }
        
        return detached
    }
}

//MARK: Branching

extension Hand {
    /// Add a branch to the given Hand to the given Hand. Since no CardTree is specified yet,
    /// returns the BranchHandCard that was created so it can be updated later with a CardTreeIdentifier.
    mutating func addBranch(to hand: Hand) -> BranchHandCard {
        guard let branchCard: BranchHandCard = CardKit.Hand.Next.Branch.typedInstance() else {
            // should never happen
            return BranchHandCard(with: CardKit.Hand.Next.Branch)
        }
        
        // set up the branch card
        branchCard.targetHandIdentifier = hand.identifier
        
        // add the hand as a subhand only if it isn't there already
        if !self.subhands.contains(hand) {
            self.subhands.append(hand)
        }
        
        // add the branch card to the hand
        self.add(branchCard)
        
        return branchCard
    }
    
    /// Add a branch to the given hand from the given CardTree. If the CardTree already has a branch
    /// to another hand, this method will update the the target to the given Hand. Returns the 
    /// BranchHandCard that was created or found.
    mutating func addBranch(from cardTree: CardTree, to hand: Hand) -> BranchHandCard {
        var branchCard: BranchHandCard? = nil
        
        // existing branch card?
        for card in self.branchCards {
            if card.cardTreeIdentifier == cardTree.identifier {
                branchCard = card
                break
            }
        }
        
        // create a new branch card if one doesn't exist
        if branchCard == nil {
            branchCard = CardKit.Hand.Next.Branch.typedInstance()
        }
        
        guard let branch = branchCard else {
            // should never happen
            return BranchHandCard(with: CardKit.Hand.Next.Branch)
        }
        
        // set up the branch card
        branch.cardTreeIdentifier = cardTree.identifier
        branch.targetHandIdentifier = hand.identifier
        
        // add the hand as a subhand only if it isn't there already
        if !self.subhands.contains(hand) {
            self.subhands.append(hand)
        }
        
        // add the branch card to the hand
        self.add(branch)
        
        return branch
    }
    
    /// Remove the branch from the given CardTree. Does not remove the subhand the branch targeted.
    /// Returns the Branch card's target HandIdentifier, or nil if no hand was specified.
    mutating func removeBranch(from cardTree: CardTree) -> HandIdentifier? {
        var candidate: BranchHandCard? = nil
        for card in self.branchCards {
            if card.cardTreeIdentifier == cardTree.identifier {
                candidate = card
                break
            }
        }
        
        if let branchCard = candidate {
            self.branchCards.removeObject(branchCard)
            return branchCard.targetHandIdentifier
        }
        
        return nil
    }
    
    /// Removes the subhand with the given HandIdentifier.
    mutating func removeSubhand(with identifier: HandIdentifier) {
        var candidate: Hand? = nil
        for hand in self.subhands {
            if hand.identifier == identifier {
                candidate = hand
            }
        }
        
        if let hand = candidate {
            self.subhands.removeObject(hand)
        }
    }
    
    /// Retrieves the branch target for the given CardTree. Returns nil if there is no
    /// Branch target specified, or no Branch card for the given CardTree.
    func branchTarget(of cardTree: CardTree) -> HandIdentifier? {
        for card in self.branchCards {
            if card.cardTreeIdentifier == cardTree.identifier {
                return card.targetHandIdentifier
            }
        }
        return nil
    }
}

//MARK: Hand Merging

extension Hand {
    /// Merges the two hands together. If there are conflicting End Rules, the one
    /// that takes precedence is the one from the hand being merged into this one.
    mutating func merge(with hand: Hand) {
        // copy in all of the CardTrees
        self.cardTrees.appendContentsOf(hand.cardTrees)
        
        // copy in all of the child hands
        self.subhands.appendContentsOf(hand.subhands)
        
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
        merged.cardTrees.appendContentsOf(self.cardTrees)
        merged.cardTrees.appendContentsOf(hand.cardTrees)
        
        // copy in the child Hands
        merged.subhands.appendContentsOf(self.subhands)
        merged.subhands.appendContentsOf(hand.subhands)
        
        // copy in the Branch cards
        merged.branchCards.appendContentsOf(self.branchCards)
        merged.branchCards.appendContentsOf(hand.branchCards)
        
        // use the EndRule card from the hand being merged in
        merged.endRuleCard = hand.endRuleCard
        
        // prefer the Repeat card from the hand being merged in
        merged.repeatCard = hand.repeatCard ?? self.repeatCard
        
        return merged
    }
    
    /// Returns a new Hand, collapsing the forest of CardTrees into a single CardTree using
    /// the logic prescribed by the End Rule (EndWhenAllSatisfied --> BooleanAnd, 
    /// EndWhenAnySatisfied --> BooleanOr). This method is used for ANDing and ORing two 
    /// Hands together; first we collapse the forest into a single tree, and then AND or 
    /// OR that tree with the other Hand. Empty CardTrees are not included in the new Hand.
    /// Branch cards are also removed in the returned Hand.
    func collapsed() -> Hand {
        var hand = Hand()
        hand.subhands = self.subhands
        hand.endRuleCard = self.endRuleCard
        hand.repeatCard = self.repeatCard
        
        // do we have any non-empty trees?
        let nonEmptyTrees = self.cardTrees.filter { $0.cardCount > 0 }
        
        if nonEmptyTrees.count == 0 {
            // we have no non-empty trees, just return
            return hand
            
        } else if nonEmptyTrees.count == 1 {
            // we have 1 non-empty tree, so just remove any empty trees and return
            hand.cardTrees = nonEmptyTrees
            return hand
        }
        
        // we have two or more non-empty trees -- merge!
        
        // build the initial node
        guard let first: CardTreeNode = nonEmptyTrees[0].root else { return hand }
        guard let second: CardTreeNode = nonEmptyTrees[1].root else { return hand }
        
        guard let combine: HandCardDescriptor =
            (self.endRule == .EndWhenAllSatisfied)
                ? CardKit.Hand.Logic.LogicalAnd
                : CardKit.Hand.Logic.LogicalOr else { return hand }
        
        guard let initial: LogicHandCard = combine.typedInstance() else { return hand }
        let initialNode: CardTreeNode = .BinaryLogic(initial, first, second)
        
        // merge
        let rest = nonEmptyTrees[2...nonEmptyTrees.endIndex]
        let newRoot = rest.reduce(initialNode) {
            (partialTreeRoot, nextTree) -> CardTreeNode in
            
            // add nextTree to partialTree
            guard let logicCard: LogicHandCard = combine.typedInstance() else { return partialTreeRoot }
            guard let nextTreeRoot = nextTree.root else { return partialTreeRoot }
            return .BinaryLogic(logicCard, partialTreeRoot, nextTreeRoot)
            
        }
        
        // make a new CardTree and add it to the new hand
        var tree = CardTree()
        tree.root = newRoot
        hand.cardTrees.append(tree)
        
        return hand
    }
    
    /// Returns a new hand by collapsing our own hand and the given hand, and combining the two 
    /// resulting CardTrees using the given HandLogicOperation. This is used by DeckBuilder for ANDing
    /// and ORing Hands together. If the HandLogicOperation is .Not or .Indeterminate, then additional
    /// logic will not be added and this method will behave just like merged().
    func collapsed(combiningWith hand: Hand, usingLogicalOperation operation: HandLogicOperation) -> Hand {
        let lhs = self.collapsed()
        let rhs = hand.collapsed()
        
        // merge into a single hand
        var merged = lhs.merged(with: rhs)
        
        guard let lhsRoot = lhs.cardTrees[0].root else { return merged }
        guard let rhsRoot = rhs.cardTrees[0].root else { return merged }
        
        // add the logical operation
        var newCard: LogicHandCard? = nil
        
        switch operation {
        case .BooleanAnd:
            newCard = CardKit.Hand.Logic.LogicalAnd.typedInstance()
        case .BooleanOr:
            newCard = CardKit.Hand.Logic.LogicalOr.typedInstance()
        case .BooleanNot, .Indeterminate:
            newCard = nil
        }
        
        // if we created a new logic card, merge the two existing trees and 
        // add it in
        if let newCard = newCard {
            merged.removeAll()
            var tree = CardTree()
            tree.root = .BinaryLogic(newCard, lhsRoot, rhsRoot)
            merged.cardTrees.append(tree)
            
        }
        
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
            "subhands": self.subhands.toJSON(),
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
        self.subhands = try json.arrayOf("sughands", type: Hand.self)
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
