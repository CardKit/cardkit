//
//  CardTree.swift
//  CardKit
//
//  Created by Justin Weisz on 8/11/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy

// MARK: CardTreeIdentifier

/// Used to uniquely identify a CardTree
public typealias CardTreeIdentifier = CardIdentifier

// MARK: - CardTree

/// A CardTree represents a tree of Logic & Action cards. CardTrees are used to 
/// determine when a Hand is satisfied (the set of CardTrees in a Hand must be 
/// satisfied according to the End Rule specified in the Hand). CardTrees are also
/// used to specify which groups of cards are part of a Branch.
public class CardTree: JSONEncodable, JSONDecodable {
    var identifier: CardTreeIdentifier = CardTreeIdentifier()
    var root: CardTreeNode?
    
    public var cards: [Card] {
        guard let root = self.root else { return [] }
        return root.cards
    }
    
    public var actionCards: [ActionCard] {
        guard let root = self.root else { return [] }
        return root.actionCards
    }
    
    public var cardCount: Int {
        return self.cards.count
    }
    
    public init() {
    }
    
    // MARK: JSONDecodable & JSONEncodable
    public required init(json: JSON) throws {
        self.identifier = try json.decode(at: "identifier", type: CardTreeIdentifier.self)
        
        let rootStr = try json.getString(at: "root")
        if rootStr == "nil" {
            self.root = nil
        } else {
            self.root = try json.decode(at: "root", type: CardTreeNode.self)
        }
    }
    
    public func toJSON() -> JSON {
        return .dictionary([
            "identifier": self.identifier.toJSON(),
            "root": self.root?.toJSON() ?? .string("nil")
            ])
    }
}

// MARK: Equatable

extension CardTree: Equatable {
    static public func == (lhs: CardTree, rhs: CardTree) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

// MARK: Hashable

extension CardTree: Hashable {
    public var hashValue: Int {
        return self.identifier.hashValue
    }
}

// MARK: CardTree Attachment

extension CardTree {
    /// Attach the given CardTree as a child of the given LogicHandCard.
    func attach(with cardTree: CardTree, asChildOf logicCard: LogicHandCard) {
        guard let root = cardTree.root else { return }
        self.attach(with: root, asChildOf: logicCard)
    }
    
    /// Attach the given CardTreeNode as a child of the given LogicHandCard.
    func attach(with node: CardTreeNode, asChildOf logicCard: LogicHandCard) {
        guard let root = self.root else { return }
        self.root = root.attached(with: node, asChildOf: logicCard)
    }
    
    /// Attach the given ActionCard as a child of the given LogicHandCard.
    func attach(with card: ActionCard, asChildOf logicCard: LogicHandCard) {
        let node: CardTreeNode = .action(card)
        self.attach(with: node, asChildOf: logicCard)
    }
    
    /// Attach the given LogicHandCard as a child of the given LogicHandCard.
    func attach(with card: LogicHandCard, asChildOf logicCard: LogicHandCard) {
        guard let node: CardTreeNode = card.asCardTreeNode() else { return }
        self.attach(with: node, asChildOf: logicCard)
    }
}

// MARK: CardTree Detachment

extension CardTree {
    /// Detach the given ActionCard from the CardTree. Returns the detached
    /// CardTreeNode, or nil if the ActionCard was not found in the tree.
    func detach(_ card: ActionCard) -> CardTreeNode? {
        guard let root = self.root else { return nil }
        self.root = root.removing(card)
        return .action(card)
    }
    
    /// Detach the given LogicHandCard from the CardTree. Returns the detached
    /// CardTreeNode, or nil if the LogicHandCard was not found in the tree.
    func detach(_ card: LogicHandCard) -> CardTreeNode? {
        guard let root = self.root else { return nil }
        guard let detached = self.cardTreeNode(of: card) else { return nil }
        let (newRoot, _) = root.removing(card)
        self.root = newRoot
        return detached
    }
}

// MARK: CardTree Removal

extension CardTree {
    /// Remove the given ActionCard from the CardTree. Returns the removed
    /// CardTreeNode, or nil if the ActionCard was not found in the tree.
    /// This method is equivalent to detach().
    func remove(_ card: ActionCard) -> CardTreeNode? {
        return self.detach(card)
    }
    
    /// Remove the given LogicHandCard from the CardTree. Returns the removed
    /// CardTreeNode and any orphaned subtrees created by removing the LogicHandCard.
    /// This method is structurally equivalent to detach(), except it also returns
    /// the orphaned CardTrees as a separate array.
    func remove(_ card: LogicHandCard) -> (CardTreeNode?, [CardTree]) {
        guard let root = self.root else { return (nil, []) }
        guard let detached = self.cardTreeNode(of: card) else { return (nil, []) }
        
        let (newRoot, orphans) = root.removing(card)
        self.root = newRoot
        
        // create new CardTrees for the orphans
        var orphanTrees: [CardTree] = []
        for orphan in orphans {
            let orphanTree = CardTree()
            orphanTree.root = orphan
            orphanTrees.append(orphanTree)
        }
        
        return (detached, orphanTrees)
    }
}

// MARK: CardTree Query

extension CardTree {
    /// Returns true if the CardTree contains a card with the given identifier.
    func contains(cardIdentifier identifier: CardIdentifier) -> Bool {
        guard let root = self.root else { return false }
        return root.contains(cardIdentifier: identifier)
    }
    
    /// Returns all ActionCards with the given descriptor.
    func cards(matching descriptor: ActionCardDescriptor) -> [ActionCard] {
        guard let root = self.root else { return [] }
        return root.cards(matching: descriptor)
    }
    
    /// Returns all HandCards with the given descriptor.
    func cards(matching descriptor: HandCardDescriptor) -> [HandCard] {
        guard let root = self.root else { return [] }
        return root.cards(matching: descriptor)
    }
    
    /// Returns the Card with the given CardIdentifier, or nil if no such card was found..
    func card(with identifier: CardIdentifier) -> Card? {
        guard let root = self.root else { return nil }
        return root.card(with: identifier)
    }
    
    /// Returns the CardTreeNode for the given LogicHandCard, or nil
    /// if no such node was found.
    func cardTreeNode(of card: LogicHandCard) -> CardTreeNode? {
        guard let root = self.root else { return nil }
        return root.cardTreeNode(of: card)
    }
}

// MARK: [CardTree] Query

extension Sequence where Iterator.Element == CardTree {
    /// Returns the CardTree containing the given ActionCard.
    func cardTree(containing card: ActionCard) -> CardTree? {
        for tree in self {
            if tree.contains(cardIdentifier: card.identifier) {
                return tree
            }
        }
        return nil
    }
    
    /// Returns the CardTree containing the given LogicHandCard.
    func cardTree(containing card: LogicHandCard) -> CardTree? {
        for tree in self {
            if tree.contains(cardIdentifier: card.identifier) {
                return tree
            }
        }
        return nil
    }
    
    /// Returns the CardTreeNode for the given LogicHandCard,
    /// or nil if the LogicHandCard isn't contained in any CardTree.
    func cardTreeNode(of card: LogicHandCard) -> CardTreeNode? {
        for tree in self {
            if let node = tree.cardTreeNode(of: card) {
                return node
            }
        }
        return nil
    }
    
    /// Returns the Card with the given CardIdentifier, or nil if no such card was found.
    func card(with identifier: CardIdentifier) -> Card? {
        for tree in self {
            if let match = tree.card(with: identifier) {
                return match
            }
        }
        return nil
    }
}

// MARK: CardTree Satisfaction

extension CardTree {
    func isSatisfied(by cards: Set<CardIdentifier>) -> Bool {
        // a CardTree with a nil root is satisfied by definition
        guard let root = self.root else { return true }
        return root.isSatisfied(by: cards)
    }
}

// MARK: Debugging

extension CardTree {
    func printToConsole(atLevel level: Int) {
        func spacePrint(_ level: Int, _ msg: String) {
            for _ in 0..<level {
                print("    ", terminator: "")
            }
            print(msg)
        }
        
        spacePrint(level, "CardTree \(self.identifier)")
        self.root?.printToConsole(atLevel: level)
    }
}
