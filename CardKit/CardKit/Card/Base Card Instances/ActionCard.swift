//
//  ActionCard.swift
//  CardKit
//
//  Created by Justin Weisz on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy

public struct ActionCard: Card {
    public let descriptor: ActionCardDescriptor
    
    // Card protocol
    public var identifier: CardIdentifier = CardIdentifier()
    public var type: CardType { return descriptor.cardType }
    public var description: String { return descriptor.description }
    public var assetCatalog: CardAssetCatalog { return descriptor.assetCatalog }
    
    // input bindings
    var inputBindings: [InputSlot : Card] = [:]
    
    // token bindings
    var tokenBindings: [TokenSlot : TokenCard] = [:]
    
    init(with descriptor: ActionCardDescriptor) {
        self.descriptor = descriptor
    }
}

//MARK: BindsWithActionCard

extension ActionCard: BindsWithActionCard {
    mutating func bind(card: ActionCard, to slot: InputSlot) {
        // it's not truly necessary to call unbind before doing the
        // re-assignment, but i'm leaving this here just in case
        // bind() / unbind() become more complicated in the future
        // and it becomes necessary.
        if self.isBound(slot) {
            self.unbind(slot)
        }
        
        self.inputBindings[slot] = card
    }
    
    mutating func unbind(slot: InputSlot) {
        self.inputBindings.removeValueForKey(slot)
    }
    
    func isBound(slot: InputSlot) -> Bool {
        guard let _ = self.inputBindings[slot] else { return false }
        return true
    }
}

//MARK: BindsWithInputCard

extension ActionCard: BindsWithInputCard {
    mutating func bind(card: InputCard, to slot: InputSlot) {
        if self.isBound(slot) {
            self.unbind(slot)
        }
        
        self.inputBindings[slot] = card
    }
    
    func inputValue(of slot: InputSlot) -> InputBinding? {
        // if this slot is bound to an Input card, then we will might have a value
        if let card = self.inputBindings[slot] as? InputCard {
            return card.inputData
        } else {
            // slot may either be bound to an ActionCard or may be unbound
            return nil
        }
    }
}

//MARK: BindsWithTokenCard

extension ActionCard: BindsWithTokenCard {
    mutating func bind(card: TokenCard, to slot: TokenSlot) {
        if self.isBound(slot) {
            self.unbind(slot)
        }
        
        self.tokenBindings[slot] = card
    }
    
    mutating func unbind(slot: TokenSlot) {
        self.tokenBindings.removeValueForKey(slot)
    }
    
    func isBound(slot: TokenSlot) -> Bool {
        guard let _ = self.tokenBindings[slot] else { return false }
        return true
    }
}

//MARK: JSONDecodable

extension ActionCard: JSONDecodable {
    public init(json: JSON) throws {
        self.identifier = try json.decode("identifier", type: CardIdentifier.self)
        self.descriptor = try json.decode("descriptor", type: ActionCardDescriptor.self)
        self.tokenBindings = try json.dictionary("tokenBindings").withDecodedKeysAndValues()
        
        let boundInputCards: [InputSlot : InputCard] = try json.dictionary("boundInputCards").withDecodedKeysAndValues()
        let boundActionCards: [InputSlot : ActionCard] = try json.dictionary("boundActionCards").withDecodedKeysAndValues()
        
        // note: if there is a slot that is multiply-bound to an Input and Action card
        // from the JSON, the Action binding will take precedence.
        self.inputBindings = [:]
        for (slot, card) in boundInputCards {
            self.bind(card, to: slot)
        }
        for (slot, card) in boundActionCards {
            self.bind(card, to: slot)
        }
    }
}

//MARK: JSONEncodable

extension ActionCard: JSONEncodable {
    public func toJSON() -> JSON {
        var boundInputCards: [InputSlot : InputCard] = [:]
        var boundActionCards: [InputSlot : ActionCard] = [:]
        
        for (k, v) in self.inputBindings {
            if let inputCard = v as? InputCard {
                boundInputCards[k] = inputCard
            } else if let actionCard = v as? ActionCard {
                boundActionCards[k] = actionCard
            }
        }
        
        return .Dictionary([
            "identifier": self.identifier.toJSON(),
            "descriptor": self.descriptor.toJSON(),
            "boundInputCards": boundInputCards.toJSON(),
            "boundActionCards": boundActionCards.toJSON(),
            "tokenBindings": self.tokenBindings.toJSON()
            ])
    }
}
