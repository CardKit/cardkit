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
    public var actionCards: [ActionCard]
    public var handCards: [HandCard]
    
    let identifier: HandIdentifier
    
    var cards: [Card] {
        var c: [Card] = []
        c.appendContentsOf(actionCards.map({ $0 as Card }))
        c.appendContentsOf(handCards.map({ $0 as Card }))
        return c
    }
    
    var count: Int {
        return actionCards.count + handCards.count
    }
    
    var lastActionCard: ActionCard? {
        return actionCards.last
    }
    
    var lastHandCard: HandCard? {
        return handCards.last
    }
    
    /// Returns the HandSatisfactionSpec from the most recently added HandCard, or nil
    /// if there are no HandCards in the hand with a LogicBinding of .SatisfactionLogic
    var lastHandSatisfactionSpec: HandSatisfactionSpec? {
        for card in self.handCards.reverse() {
            if let cardLogic = card.logic {
                switch cardLogic {
                case .SatisfactionLogic(let spec):
                    return spec
                default:
                    continue
                }
            }
        }
        return nil
    }
    
    init() {
        self.init()
    }
    
    mutating func add(card: ActionCard) {
        self.actionCards.append(card)
    }
    
    mutating func add(cards: [ActionCard]) {
        self.actionCards.appendContentsOf(cards)
    }
    
    mutating func add(card: HandCard) {
        self.handCards.append(card)
    }
    
    mutating func add(cards: [HandCard]) {
        self.handCards.appendContentsOf(cards)
    }
    
    mutating func addCards(from hand: Hand) {
        for card in hand.actionCards {
            self.add(card)
        }
        for card in hand.handCards {
            self.add(card)
        }
    }
    
    mutating func remove(card: ActionCard) {
        self.actionCards.removeObject(card)
    }
    
    mutating func remove(cards: [ActionCard]) {
        for card in cards {
            self.actionCards.removeObject(card)
        }
    }
    
    mutating func remove(card: HandCard) {
        self.handCards.removeObject(card)
    }
    
    mutating func remove(cards: [HandCard]) {
        for card in cards {
            self.handCards.removeObject(card)
        }
    }
}

//MARK: JSONDecodable

extension Hand: JSONDecodable {
    public init(json: JSON) throws {
        self.actionCards = try json.arrayOf("actionCards", type: ActionCard.self)
        self.handCards = try json.arrayOf("handCards", type: HandCard.self)
        self.identifier = try json.decode("identifier", type: HandIdentifier.self)
    }
}

//MARK: JSONEncodable

extension Hand: JSONEncodable {
    public func toJSON() -> JSON {
        return .Dictionary([
            "actionCards": self.actionCards.toJSON(),
            "handCards": self.handCards.toJSON(),
            "identifier": self.identifier.toJSON(),
            ])
    }
}
