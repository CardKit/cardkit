//
//  CardTree.swift
//  CardKit
//
//  Created by Justin Weisz on 8/11/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy

//MARK: CardTreeIdentifier

/// Used to uniquely identify a CardTree
public typealias CardTreeIdentifier = CardIdentifier

//MARK:- CardTree

/// A CardTree represents a tree of Logic & Action cards. CardTrees are used to 
/// determine when a Hand is satisfied (the set of CardTrees in a Hand must be 
/// satisfied according to the End Rule specified in the Hand). CardTrees are also
/// used to specify which groups of cards are part of a Branch.
public class CardTree: JSONEncodable, JSONDecodable {
    var identifier: CardTreeIdentifier = CardTreeIdentifier()
    var root: CardTreeNode? = nil
    
    public var cards: [Card] {
        guard let root = self.root else { return [] }
        return root.cards
    }
    
    public var cardCount: Int {
        return self.cards.count
    }
    
    public init() {
    }
    
    //MARK: JSONDecodable & JSONEncodable
    public required init(json: JSON) throws {
        self.identifier = try json.decode("identifier", type: CardTreeIdentifier.self)
        
        let rootStr = try json.string("root")
        if rootStr == "nil" {
            self.root = nil
        } else {
            self.root = try json.decode("root", type: CardTreeNode.self)
        }
    }
    
    public func toJSON() -> JSON {
        return .Dictionary([
            "identifier": self.identifier.toJSON(),
            "root": self.root?.toJSON() ?? .String("nil")
            ])
    }
}

//MARK: Equatable

extension CardTree: Equatable {}

public func == (lhs: CardTree, rhs: CardTree) -> Bool {
    return lhs.identifier == rhs.identifier
}

//MARK: Hashable

extension CardTree: Hashable {
    public var hashValue: Int {
        return self.identifier.hashValue
    }
}

//MARK: CardTree Attachment

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
        let node: CardTreeNode = .Action(card)
        self.attach(with: node, asChildOf: logicCard)
    }
    
    /// Attach the given LogicHandCard as a child of the given LogicHandCard.
    func attach(with card: LogicHandCard, asChildOf logicCard: LogicHandCard) {
        guard let node: CardTreeNode = card.asCardTreeNode() else { return }
        self.attach(with: node, asChildOf: logicCard)
    }
}

//MARK: CardTree Removal

extension CardTree {
    /// Remove the given ActionCard from the CardTree.
    func remove(card: ActionCard) {
        guard let root = self.root else { return }
        self.root = root.removing(card)
    }
    
    /// Remove the given LogicHandCard from the CardTree. Returns any orphaned subtrees
    /// created by removing the LogicHandCard.
    func remove(card: LogicHandCard) -> [CardTree] {
        guard let root = self.root else { return [] }
        let (newRoot, orphans) = root.removing(card)
        self.root = newRoot
        
        // create new CardTrees for the orphans
        var orphanTrees: [CardTree] = []
        for orphan in orphans {
            let orphanTree = CardTree()
            orphanTree.root = orphan
            orphanTrees.append(orphanTree)
        }
        
        return orphanTrees
    }
}

//MARK: CardTree Query

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

//MARK: [CardTree] Query

extension SequenceType where Generator.Element == CardTree {
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

//MARK: Debugging

extension CardTree {
    func printToConsole(atLevel level: Int) {
        func spacePrint(level: Int, _ msg: String) {
            for _ in 0..<level {
                print("    ", terminator: "")
            }
            print(msg)
        }
        
        spacePrint(level, "CardTree \(self.identifier)")
        self.root?.printToConsole(atLevel: level)
    }
}
