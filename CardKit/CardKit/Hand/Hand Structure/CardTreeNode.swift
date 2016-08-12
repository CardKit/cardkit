//
//  CardTreeNode.swift
//  CardKit
//
//  Created by Justin Weisz on 8/12/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy

//MARK: CardTreeNode

public indirect enum CardTreeNode {
    case Action(ActionCard)
    case UnaryLogic(LogicHandCard, CardTreeNode?)
    case BinaryLogic(LogicHandCard, CardTreeNode?, CardTreeNode?)
    
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

//MARK: Equatable

extension CardTreeNode: Equatable {}

/// CardTrees are equal when they are structually equivalent.
public func == (lhs: CardTreeNode, rhs: CardTreeNode) -> Bool {
    if case .Action(let lhsActionCard) = lhs,
        case .Action(let rhsActionCard) = rhs {
        return lhsActionCard == rhsActionCard
    }
    
    if case .UnaryLogic(let lhsLogicCard, let lhsSubtree) = lhs,
        case .UnaryLogic(let rhsLogicCard, let rhsSubtree) = rhs {
        if lhsLogicCard == rhsLogicCard {
            return lhsSubtree == rhsSubtree
        } else {
            return false
        }
    }
    
    if case .BinaryLogic(let lhsLogicCard, let lhsLeft, let lhsRight) = lhs,
        case .BinaryLogic(let rhsLogicCard, let rhsLeft, let rhsRight) = rhs {
        if lhsLogicCard == rhsLogicCard {
            return lhsLeft == rhsLeft && lhsRight == rhsRight
        } else {
            return false
        }
    }
    
    return false
}

//MARK: Hashable

extension CardTreeNode: Hashable {
    public var hashValue: Int {
        switch self {
        case .Action(let actionCard):
            return actionCard.hashValue
        case .UnaryLogic(let logicCard, let subtree):
            if let subtree = subtree {
                return logicCard.hashValue &+ subtree.hashValue
            } else {
                return logicCard.hashValue
            }
        case .BinaryLogic(let logicCard, let left, let right):
            var hash: Int = logicCard.hashValue
            if let left = left {
                hash = hash &+ left.hashValue
            }
            if let right = right {
                hash = hash &+ right.hashValue
            }
            return hash
        }
    }
}

//MARK: JSONEncodable

extension CardTreeNode: JSONEncodable {
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

extension CardTreeNode: JSONDecodable {
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
                let subtree = try json.decode("subtree", type: CardTreeNode.self)
                self = .UnaryLogic(logicCard, subtree)
            }
        case "BinaryLogic":
            let logicCard = try json.decode("logicCard", type: LogicHandCard.self)
            
            let leftStr = try json.string("leftSubtree")
            let rightStr = try json.string("rightSubtree")
            
            var left: CardTreeNode? = nil
            var right: CardTreeNode? = nil
            
            if leftStr != "nil" {
                left = try json.decode("leftSubtree", type: CardTreeNode.self)
            }
            
            if rightStr != "nil" {
                right = try json.decode("rightSubtree", type: CardTreeNode.self)
            }
            
            self = .BinaryLogic(logicCard, left, right)
            
        default:
            throw JSON.Error.ValueNotConvertible(value: json, to: CardTreeNode.self)
        }
    }
}

//MARK: CardTreeNode Attachment

extension CardTreeNode {
    /// Returns a new CardTreeNode with the given CardTreeNode attached as a child of the given LogicHandCard
    func attached(with treeNode: CardTreeNode, asChildOf logicCard: LogicHandCard) -> CardTreeNode {
        
        func attached(with cardTree: CardTreeNode, asChildOf logicCard: LogicHandCard, atNode node: CardTreeNode) -> CardTreeNode {
            switch node {
            case .Action(let actionCard):
                return .Action(actionCard)
            case .UnaryLogic(let logic, let subtree):
                if logic == logicCard && subtree == nil {
                    // got it, attach the cardTree
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
        
        return attached(with: treeNode, asChildOf: logicCard, atNode: treeNode)
    }
}

//MARK: CardTreeNode Removal

extension CardTreeNode {
    /// Returns a new CardTreeNode without the given ActionCard.
    func removing(card: ActionCard) -> CardTreeNode? {
        switch self {
        case .Action(let actionCard):
            return card == actionCard ? nil : .Action(actionCard)
        case .UnaryLogic(let logicCard, let subtree):
            return .UnaryLogic(logicCard, subtree?.removing(card))
        case .BinaryLogic(let logicCard, let left, let right):
            return .BinaryLogic(logicCard, left?.removing(card), right?.removing(card))
        }
    }
    
    /// Remove a LogicHandCard from a CardTreeNode. Returns the root of the new tree,
    /// as well as any oprhan subtrees that were created by removing the card.
    /// (e.g. children of a {Unary,Binary}Logic tree).
    func removing(card: LogicHandCard) -> (CardTreeNode?, [CardTreeNode]) {
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
                    let (newSubtree, orphans) = subtree.removing(card)
                    return (.UnaryLogic(logicCard, newSubtree), orphans)
                } else {
                    return (nil, [])
                }
            }
            
        case .BinaryLogic(let logicCard, let left, let right):
            if card == logicCard {
                var orphans: [CardTreeNode] = []
                if let l = left {
                    orphans.append(l)
                }
                if let r = right {
                    orphans.append(r)
                }
                return (nil, orphans)
            } else {
                var newLeft: CardTreeNode? = nil
                var orphansLeft: [CardTreeNode] = []
                var newRight: CardTreeNode? = nil
                var orphansRight: [CardTreeNode] = []
                
                if let left = left {
                    (newLeft, orphansLeft) = left.removing(card)
                }
                if let right = right {
                    (newRight, orphansRight) = right.removing(card)
                }
                
                var orphans: [CardTreeNode] = []
                orphans.appendContentsOf(orphansLeft)
                orphans.appendContentsOf(orphansRight)
                return (.BinaryLogic(logicCard, newLeft, newRight), orphans)
            }
        }
    }
}

//MARK: CardTreeNode Query

extension CardTreeNode {
    /// Returns true if the CardTreeNode contains a card with the given identifier.
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
    
    /// Returns the CardTreeNode for the given LogicHandCard, or nil
    /// if no such node was found.
    func cardTreeNode(of card: LogicHandCard) -> CardTreeNode? {
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
            var node: CardTreeNode? = nil
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
    }
}
