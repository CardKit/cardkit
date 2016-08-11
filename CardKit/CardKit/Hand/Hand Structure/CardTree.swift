//
//  CardTree.swift
//  CardKit
//
//  Created by Justin Weisz on 8/11/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy

public indirect enum CardTree {
    case Action(ActionCard)
    case UnaryLogic(LogicHandCard, CardTree?)
    case BinaryLogic(LogicHandCard, CardTree?, CardTree?)
    
    public var cards: [Card] {
        switch self {
        case .Action(let actionCard):
            return [actionCard]
        case .UnaryLogic(let logicCard, let subtree):
            var cards: [Card] = []
            cards.append(logicCard)
            if let subtree = subtree {
                cards.appendContentsOf(subtree.cards)
            }
            return cards
        case .BinaryLogic(let logicCard, let left, let right):
            var cards: [Card] = []
            cards.append(logicCard)
            if let left = left {
                cards.appendContentsOf(left.cards)
            }
            if let right = right {
                cards.appendContentsOf(right.cards)
            }
            return cards
        }
    }
}

//MARK: CardTree Attachment

extension CardTree {
    /// Returns a new CardTree with the given CardTree node attached as a child of the given LogicHandCard
    func attached(with cardTree: CardTree, asChildOf logicCard: LogicHandCard) -> CardTree {
        
        func attached(with cardTree: CardTree, asChildOf: LogicHandCard, atNode node: CardTree) -> CardTree {
            switch node {
            case .Action(let actionCard):
                return .Action(actionCard)
            case .UnaryLogic(let logic, let subtree):
                if logic == logicCard && subtree == nil {
                    // got it, attach the action card
                    return .UnaryLogic(logic, cardTree)
                } else {
                    // oops, either this isn't the LogicCard we are looking for, or 
                    // it is and it already has something attached
                    return .UnaryLogic(logic, subtree)
                }
            case .BinaryLogic(let logic, let left, let right):
                if logic == logicCard {
                    if left == nil {
                        // free slot in left child
                        return .BinaryLogic(logic, cardTree, right)
                    } else if right == nil {
                        // free slot in right child
                        return .BinaryLogic(logic, left, cardTree)
                    } else {
                        // oops no free slots
                        return .BinaryLogic(logic, left, right)
                    }
                } else {
                    // this is not the card we are looking for
                    return .BinaryLogic(logic, left, right)
                }
            }
        }
        
        return self.attached(with: cardTree, asChildOf: logicCard)
    }
}

//MARK: CardTree Removal

extension CardTree {
    /// Returns a new CardTree without the given ActionCard.
    func cardTree(removing card: ActionCard) -> CardTree? {
        switch self {
        case .Action(let actionCard):
            return card == actionCard ? nil : .Action(actionCard)
        case .UnaryLogic(let logicCard, let subtree):
            return .UnaryLogic(logicCard, subtree?.cardTree(removing: card))
        case .BinaryLogic(let logicCard, let left, let right):
            return .BinaryLogic(logicCard, left?.cardTree(removing: card), right?.cardTree(removing: card))
        }
    }
    
    /// Remove a LogicHandCard from a CardTree. Returns the root of the new tree, 
    /// as well as any oprhan subtrees that were created by removing the card.
    /// (e.g. children of a {Unary,Binary}Logic tree).
    func cardTree(removing card: LogicHandCard) -> (CardTree?, [CardTree]) {
        switch self {
        case .Action(let actionCard):
            return (.Action(actionCard), [])
            
        case .UnaryLogic(let logicCard, let subtree):
            if card == logicCard {
                if let subtree = subtree {
                    return (nil, [subtree])
                } else {
                    return (nil, [])
                }
            } else {
                if let subtree = subtree {
                    let (newSubtree, orphans) = subtree.cardTree(removing: card)
                    return (.UnaryLogic(logicCard, newSubtree), orphans)
                } else {
                    return (nil, [])
                }
            }
            
        case .BinaryLogic(let logicCard, let left, let right):
            if card == logicCard {
                var orphans: [CardTree] = []
                if let l = left {
                    orphans.append(l)
                }
                if let r = right {
                    orphans.append(r)
                }
                return (nil, orphans)
            } else {
                var newLeft: CardTree? = nil
                var orphansLeft: [CardTree] = []
                var newRight: CardTree? = nil
                var orphansRight: [CardTree] = []
                
                if let left = left {
                    (newLeft, orphansLeft) = left.cardTree(removing: card)
                }
                if let right = right {
                    (newRight, orphansRight) = right.cardTree(removing: card)
                }
                
                var orphans: [CardTree] = []
                orphans.appendContentsOf(orphansLeft)
                orphans.appendContentsOf(orphansRight)
                return (.BinaryLogic(logicCard, newLeft, newRight), orphans)
            }
        }
    }
}

//MARK: CardTree Query

extension CardTree {
    /// Returns true if the CardTree contains a card with the given identifier.
    func contains(cardIdentifier identifier: CardIdentifier) -> Bool {
        switch self {
        case .Action(let actionCard):
            return identifier == actionCard.identifier
        case .UnaryLogic(let logicCard, let subtree):
            if identifier == logicCard.identifier {
                return true
            }
            
            if let subtree = subtree {
                return subtree.contains(cardIdentifier: identifier)
            } else {
                return false
            }
        case .BinaryLogic(let logicCard, let left, let right):
            if identifier == logicCard.identifier {
                return true
            }
            
            var leftContains = false
            var rightContains = false
            if let left = left {
                leftContains = left.contains(cardIdentifier: identifier)
            }
            if let right = right {
                rightContains = right.contains(cardIdentifier: identifier)
            }
            
            return leftContains || rightContains
        }
    }
    
    /// Returns the parent CardTree node for the given ActionCard, or nil
    /// if no such node was found.
    /*func parentCardTreeNode(of card: ActionCard) -> CardTree? {
        
        /// Helper method to keep track of the parent node as we recurse down the tree.
        func parentNode(of card: ActionCard, fromTree tree: CardTree?, havingParent parent: CardTree?) -> CardTree? {
            switch self {
            case .Action(let actionCard):
                if actionCard == card {
                    return parent
                } else {
                    return nil
                }
            case .UnaryLogic(_, let subtree):
                if let subtree = subtree {
                    return parentNode(of: card, fromTree: subtree, havingParent: self)
                } else {
                    return nil
                }
            case .BinaryLogic(_, let left, let right):
                var parent: CardTree? = nil
                if let left = left {
                    parent = parentNode(of: card, fromTree: left, havingParent: self)
                }
                if parent == nil {
                    if let right = right {
                        parent = parentNode(of: card, fromTree: right, havingParent: self)
                    }
                }
                return parent
            }
        }
        
        return parentNode(of: card, fromTree: self, havingParent: nil)
    }*/
    
    /// Returns the CardTree node for the given LogicHandCard, or nil
    /// if no such node was found.
    /*func cardTreeNode(of card: LogicHandCard) -> CardTree? {
        switch self {
        case .Action(_):
            return nil
        case .UnaryLogic(let logicCard, let subtree):
            if logicCard == card {
                return self
            }
            
            if let subtree = subtree {
                return subtree.cardTreeNode(of: card)
            } else {
                return nil
            }
        case .BinaryLogic(let logicCard, let left, let right):
            if logicCard == card {
                return self
            }
            var node: CardTree? = nil
            if let left = left {
                node = left.cardTreeNode(of: card)
            }
            if node == nil {
                if let right = right {
                    node = right.cardTreeNode(of: card)
                }
            }
            
            return node
        }
    }*/
    
    /// Returns all ActionCards with the given descriptor.
    func cards(matching descriptor: ActionCardDescriptor) -> [ActionCard] {
        switch self {
        case .Action(let actionCard):
            if actionCard.descriptor == descriptor {
                return [actionCard]
            } else {
                return []
            }
        case .UnaryLogic(_, let subtree):
            if let subtree = subtree {
                return subtree.cards(matching: descriptor)
            } else {
                return []
            }
        case .BinaryLogic(_, let left, let right):
            var matching: [ActionCard] = []
            if let left = left {
                matching.appendContentsOf(left.cards(matching: descriptor))
            }
            if let right = right {
                matching.appendContentsOf(right.cards(matching: descriptor))
            }
            return matching
        }
    }
    
    /// Returns all LogicHandCards with the given descriptor.
    func cards(matching descriptor: HandCardDescriptor) -> [LogicHandCard] {
        switch self {
        case .Action(_):
            return []
        case .UnaryLogic(let logicCard, let subtree):
            var matching: [LogicHandCard] = []
            if logicCard.descriptor == descriptor {
                matching.append(logicCard)
            }
            if let subtree = subtree {
                matching.appendContentsOf(subtree.cards(matching: descriptor))
            }
            return matching
        case .BinaryLogic(let logicCard, let left, let right):
            var matching: [LogicHandCard] = []
            if logicCard.descriptor == descriptor {
                matching.append(logicCard)
            }
            if let left = left {
                matching.appendContentsOf(left.cards(matching: descriptor))
            }
            if let right = right {
                matching.appendContentsOf(right.cards(matching: descriptor))
            }
            return matching
        }
    }
    
    /// Returns the Card with the given CardIdentifier, or nil if no such card was found..
    func card(with identifier: CardIdentifier) -> Card? {
        switch self {
        case .Action(let actionCard):
            return actionCard.identifier == identifier ? actionCard : nil
            
        case .UnaryLogic(let logicCard, let subtree):
            if logicCard.identifier == identifier {
                return logicCard
            }
            
            if let subtree = subtree {
                return subtree.card(with: identifier)
            }
            
            return nil
            
        case .BinaryLogic(let logicCard, let left, let right):
            if logicCard.identifier == identifier {
                return logicCard
            }
            
            var foundCard: Card? = nil
            if let left = left {
                foundCard = left.card(with: identifier)
            }
            if foundCard == nil {
                if let right = right {
                    foundCard = right.card(with: identifier)
                }
            }
            
            return foundCard
        }
    }
}

//MARK: [CardTree] Query

extension Array where Element : CardTree {
    /// Returns CardTree containing the given ActionCard.
    func cardTree(containing card: ActionCard) -> CardTree? {
        for tree in self {
            if tree.contains(cardIdentifier: card.identifier) {
                return tree
            }
        }
        return nil
    }
    
    /// Returns CardTree containing the given LogicHandCard.
    func cardTree(containing card: LogicHandCard) -> CardTree? {
        for tree in self {
            if tree.contains(cardIdentifier: card.identifier) {
                return tree
            }
        }
        return nil
    }
    
    /// Returns the specific CardTree node corresponding to the given LogicHandCard,
    /// or nil if the LogicHandCard isn't contained in any CardTree.
    func cardTreeNode(of card: LogicHandCard) -> CardTree? {
        for tree in self {
            if let root = tree.cardTreeNode(of: card) {
                return root
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

//MARK: JSONEncodable

extension CardTree: JSONEncodable {
    public func toJSON() -> JSON {
        switch self {
        case .Action(let actionCard):
            return .Dictionary([
                "type": "Action",
                "card": actionCard.toJSON()
                ])
        case .UnaryLogic(let logicCard, let subtree):
            return .Dictionary([
                "type": "UnaryLogic",
                "logicCard": logicCard.toJSON(),
                "subtree": subtree?.toJSON() ?? .String("nil")
                ])
        case .BinaryLogic(let logicCard, let left, let right):
            return .Dictionary([
                "type": "BinaryLogic",
                "logicCard": logicCard.toJSON(),
                "leftSubtree": left?.toJSON() ?? .String("nil"),
                "rightSubtree": right?.toJSON() ?? .String("nil")
                ])
        }
    }
}

//MARK: JSONDecodable

extension CardTree: JSONDecodable {
    public init(json: JSON) throws {
        let type = try json.string("type")
        
        switch type {
        case "Action":
            let actionCard = try json.decode("actionCard", type: ActionCard.self)
            self = .Action(actionCard)
        case "UnaryLogic":
            let logicCard = try json.decode("logicCard", type: LogicHandCard.self)
            
            let subtreeStr = try json.string("subtree")
            if subtreeStr == "nil" {
                self = .UnaryLogic(logicCard, nil)
            } else {
                let subtree = try json.decode("subtree", type: CardTree.self)
                self = .UnaryLogic(logicCard, subtree)
            }
        case "BinaryLogic":
            let logicCard = try json.decode("logicCard", type: LogicHandCard.self)
            
            let leftStr = try json.string("leftSubtree")
            let rightStr = try json.string("rightSubtree")
            
            var left: CardTree? = nil
            var right: CardTree? = nil
            
            if leftStr != "nil" {
                left = try json.decode("leftSubtree", type: CardTree.self)
            }
            
            if rightStr != "nil" {
                right = try json.decode("rightSubtree", type: CardTree.self)
            }
            
            self = .BinaryLogic(logicCard, left, right)
            
        default:
            throw JSON.Error.ValueNotConvertible(value: json, to: CardTree.self)
        }
    }
}
