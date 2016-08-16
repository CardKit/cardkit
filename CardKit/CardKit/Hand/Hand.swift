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

public class Hand: JSONEncodable, JSONDecodable {
    /// A Hand is a forest of CardTrees. Each CardTree encapsulates a set of
    /// LogicHandCards and ActionCards. A CardTree may be associated with a BranchHandCard
    /// in the case that upon satisfaction of the CardTree's logic, execution branches
    /// to the target of the BranchHandCard.
    var cardTrees: [CardTree] = []
    
    /// The set of Hands to which this Hand may branch.
    public private (set) var subhands: [Hand] = []
    
    /// These cards specify which CardTree branches to which child Hand.
    public private (set) var branchCards: [BranchHandCard] = []
    
    /// Specifies whether the hand should repeat a number of times
    public private (set) var repeatCard: RepeatHandCard? = nil
    
    /// Specifies the End Rule that governs the logic of this Hand. The default
    /// is that ALL cards in the hand must End before moving to the next Hand.
    /// There may only be one EndRuleCard in a Hand.
    private (set) var endRuleCard: EndRuleHandCard = EndRuleHandCard(with: CardKit.Hand.End.All)
    
    /// Unique identifier for the Hand
    public var identifier: HandIdentifier = HandIdentifier()
    
    /// Returns all of the Cards in the Hand, including ActionCards (with their bound InputCards),
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
    
    /// Returns all of the ActionCards in the Hand.
    public var actionCards: [ActionCard] {
        var cards: [ActionCard] = []
        self.cardTrees.forEach { cards.appendContentsOf($0.actionCards) }
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
    
    /// The number of cards in this hand, as well as the number of cards
    /// recursively stored in all subhands.
    public var nestedCardCount: Int {
        return self.cards.count + self.subhands.reduce(0) {
            (count, hand) in count + hand.nestedCardCount
        }
    }
    
    /// A complete list of all nested subhands accessible from this Hand.
    public var nestedSubhands: [Hand] {
        var hands: [Hand] = []
        hands.appendContentsOf(self.subhands)
        self.subhands.forEach { hands.appendContentsOf($0.nestedSubhands) }
        return hands
    }
    
    /// The number of subhands recursively stored in this hand.
    public var nestedSubhandCount: Int {
        return self.subhands.count + self.subhands.reduce(0) {
            (count, hand) in count + hand.nestedSubhandCount
        }
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
    
    init() {
    }
    
    //MARK: JSONEncodable & JSONDecodable
    
    public required init(json: JSON) throws {
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

//MARK: Card Addition

extension Hand {
    /// Add the card to the hand if it isn't in the hand already.
    func add(card: ActionCard) {
        if !self.contains(card) {
            // make a new CardTree with the card
            let tree = CardTree()
            tree.root = .Action(card)
            self.cardTrees.append(tree)
        }
    }
    
    /// Add the given cards to the hand, ignoring cards that have already
    /// been added to the hand.
    func add(cards: [ActionCard]) {
        cards.forEach { self.add($0) }
    }
    
    /// Add the HandCard to the hand if it isn't in the hand already.
    func add(card: HandCard) {
        if !self.contains(card) {
            // figure out what this is to know where to add it
            switch card.descriptor.handCardType {
            case .BooleanLogicAnd, .BooleanLogicOr:
                guard let logicCard = card as? LogicHandCard else { return }
                let tree = CardTree()
                tree.root = .BinaryLogic(logicCard, nil, nil)
                self.cardTrees.append(tree)
            case .BooleanLogicNot:
                guard let logicCard = card as? LogicHandCard else { return }
                let tree = CardTree()
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
    func add(cards: [HandCard]) {
        cards.forEach { self.add($0) }
    }
}

//MARK: Card Attachment

extension Hand {
    /// Attaches an ActionCard to nest under a LogicHandCard. Fails if the destination
    /// already has its child slots filled.
    public func attach(card: ActionCard, to destination: LogicHandCard) {
        // create a new CardTree for destination if it isn't in the Hand yet
        if self.cardTrees.cardTree(containing: destination) == nil {
            guard let newTree = destination.asCardTree() else { return }
            self.cardTrees.append(newTree)
        }
        
        // get the destination tree -- should always work because we just created it if it didn't exist
        guard let destinationTree = self.cardTrees.cardTree(containing: destination) else { return }
        
        // detach card from the CardTree it's in
        if let detached = self.cardTrees.cardTree(containing: card)?.detach(card) {
            // re-attach
            destinationTree.attach(with: detached, asChildOf: destination)
        } else {
            // add the card and attach it
            destinationTree.attach(with: card, asChildOf: destination)
        }
        
        // remove any empty CardTrees that were created
        self.removeEmptyCardTrees()
    }
    
    /// Attaches a LogicHandCard to nest under another LogicHandCard. Fails if the destination
    /// already has its child slots filled.
    public func attach(card: LogicHandCard, to destination: LogicHandCard) {
        // create a new CardTree for destination if it isn't in the Hand yet
        if self.cardTrees.cardTree(containing: destination) == nil {
            guard let newTree = destination.asCardTree() else { return }
            self.cardTrees.append(newTree)
        }
        
        // get the destination tree -- should always work because we just created it if it didn't exist
        guard let destinationTree = self.cardTrees.cardTree(containing: destination) else { return }
        
        // detach card from the CardTree it's in
        if let detached = self.cardTrees.cardTree(containing: card)?.detach(card) {
            // re-attach
            destinationTree.attach(with: detached, asChildOf: destination)
        } else {
            // add the card and attach it
            destinationTree.attach(with: card, asChildOf: destination)
        }
        
        // remove any empty CardTrees that were created
        self.removeEmptyCardTrees()
    }
}

//MARK: Card Detachment

extension Hand {
    /// Detaches an ActionCard from its parent. Detaching an ActionCard keeps it in the Hand, but 
    /// detaches it from the LogicHandCard to which it was attached.
    public func detach(card: ActionCard) {
        guard let tree = self.cardTrees.cardTree(containing: card) else { return }
        let detached = tree.detach(card)
        
        // add back as a new CardTree
        let newTree = CardTree()
        newTree.root = detached
        self.cardTrees.append(newTree)
        
        // remove any empty CardTrees that were created
        self.removeEmptyCardTrees()
    }
    
    /// Detaches a LogicHandCard from its parent. Detaching a LogicHandCard keeps it in the Hand, but
    /// detaches it from the LogicHandCard to which it was attached.
    public func detach(card: LogicHandCard) {
        guard let tree = self.cardTrees.cardTree(containing: card) else { return }
        let detached = tree.detach(card)
        
        // add back as a new CardTree
        let newTree = CardTree()
        newTree.root = detached
        self.cardTrees.append(newTree)
        
        // remove any empty CardTrees that were created
        self.removeEmptyCardTrees()
    }
    
    /// Removes empty CardTrees that may have been produced as a result of remove()
    /// attach(), or detach() operations.
    private func removeEmptyCardTrees() {
        self.cardTrees = self.cardTrees.filter { $0.cardCount > 0 }
    }
}

//MARK: Card Removal

extension Hand {
    /// Remove the given card from the hand.
    public func remove(card: ActionCard) {
        guard let tree = self.cardTrees.cardTree(containing: card) else { return }
        tree.remove(card)
    }
    
    /// Remove the given cards from the hand.
    public func remove(cards: [ActionCard]) {
        cards.forEach { self.remove($0) }
    }
    
    /// Remove the given card from the hand. LogicHandCards that are removed will have their orphaned children
    /// added back to the Hand. EndRule cards with the rule EndWhenAllSatisfied cannot be removed as this 
    /// is the default.
    public func remove(card: HandCard) {
        // figure out what this is to know how to remove it
        switch card.descriptor.handCardType {
        case .BooleanLogicAnd, .BooleanLogicOr, .BooleanLogicNot:
            guard let logicCard = card as? LogicHandCard else { return }
            guard let tree = self.cardTrees.cardTree(containing: logicCard) else { return }
            
            // remove the card
            let (_, orphans) = tree.remove(logicCard)
            
            // add the orphans back to the Hand
            self.cardTrees.appendContentsOf(orphans)
            
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
    public func remove(cards: [HandCard]) {
        cards.forEach { self.remove($0) }
    }
    
    /// Remove all cards from the hand. Does not remove the End Rule card, or any
    /// cards in child Hands.
    public func removeAll() {
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

//MARK: Branching

extension Hand {
    /// Add a branch to the given Hand to the given Hand. Since no CardTree is specified yet,
    /// returns the BranchHandCard that was created so it can be updated later with a CardTreeIdentifier if needed.
    /// Otherwise, the branch will occur when the entire Hand is satisfied.
    func addBranch(to hand: Hand) -> BranchHandCard {
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
    func addBranch(from cardTree: CardTree, to hand: Hand) -> BranchHandCard {
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
    
    /// Remove the branch from the Hand to the given Hand. Removes all BranchHandCards with a targetHandIdentifier matching the given Hand. Does not remove the subhand the branch 
    /// targeted.
    func removeBranches(to hand: Hand) {
        // remove everything that targets hand.identifier
        self.branchCards = self.branchCards.filter { $0.targetHandIdentifier != hand.identifier }
    }
    
    /// Remove the branch from the given CardTree. Does not remove the subhand the branch targeted.
    /// Returns the Branch card's target HandIdentifier, or nil if no hand was specified.
    func removeBranch(from cardTree: CardTree) -> HandIdentifier? {
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
    
    /// Returns true if the Hand contains the given Hand. Operates recursively.
    func contains(hand: Hand) -> Bool {
        // check our subhands
        let contains = self.subhands.reduce(false) {
            (contains, subhand) in contains || subhand == hand
        }
        // if we don't have it, see if our subhands has it
        if !contains {
            return self.subhands.reduce(false) {
                (contains, subhand) in contains || subhand.contains(hand)
            }
        }
        return contains
    }
    
    /// Removes the given Hand from the Hand. Does not remove any BranchHandCards that branch to this hand. Operates recursively.
    func remove(hand: Hand) {
        // filter out the hand from my subhands
        self.subhands = self.subhands.filter { $0 != hand }
        
        // filter out the hand from my children
        for subhand in self.subhands {
            subhand.remove(hand)
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
    func merge(with hand: Hand) {
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
        let merged: Hand = Hand()
        
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
        let hand = Hand()
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
        let tree = CardTree()
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
        let merged = lhs.merged(with: rhs)
        
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
            let tree = CardTree()
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

//MARK: Debugging

extension Hand {
    func printToConsole(atLevel level: Int) {
        func spacePrint(level: Int, _ msg: String) {
            for _ in 0..<level {
                print("    ", terminator: "")
            }
            print(msg)
        }
        
        spacePrint(level, "------")
        spacePrint(level, "Hand \(self.identifier)")
        spacePrint(level, "* cardTrees:")
        self.cardTrees.forEach { $0.printToConsole(atLevel: level) }
        spacePrint(level, "* branch cards:")
        self.branchCards.forEach { spacePrint(level, "\($0.description)") }
        spacePrint(level, "* repeat card:")
        if let repeatCard = self.repeatCard {
            spacePrint(level, "\(repeatCard.description)")
        }
        spacePrint(level, "* end rule:")
        spacePrint(level, "\(self.endRuleCard.description)")
        spacePrint(level, "* subhands:")
        self.subhands.forEach { $0.printToConsole(atLevel: level + 1) }
        spacePrint(level, "------")
    }
}
