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
    public var cardType: CardType { return descriptor.cardType }
    public var description: String { return descriptor.description }
    public var assetCatalog: CardAssetCatalog { return descriptor.assetCatalog }
    
    // input bindings
    var inputBindings: [InputSlot : Card] = [:]
    
    // token bindings
    var tokenBindings: [TokenSlot : TokenCard] = [:]
    
    init(with descriptor: ActionCardDescriptor) {
        self.descriptor = descriptor
    }
    
    init(with descriptor: ActionCardDescriptor, inputBindings: [InputSlot : Card], tokenBindings: [TokenSlot : TokenCard]) {
        self.descriptor = descriptor
        self.inputBindings = inputBindings
        self.tokenBindings = tokenBindings
    }
}

//MARK: BindsWithActionCard

extension ActionCard: BindsWithActionCard {
    /// Binds the given ActionCard to the specified InputSlot
    mutating func bind(with card: ActionCard, in slot: InputSlot) {
        self.inputBindings[slot] = card
    }
    
    /// Unbinds the card that was bound to the specified InputSlot
    mutating func unbind(slot: InputSlot) {
        self.inputBindings.removeValueForKey(slot)
    }
    
    /// Returns a new ActionCard with the given ActionCard bound to the specified InputSlot
    func bound(with card: ActionCard, in slot: InputSlot) -> ActionCard {
        var newInputBindings = inputBindings
        newInputBindings[slot] = card
        return ActionCard(with: self.descriptor, inputBindings: newInputBindings, tokenBindings: self.tokenBindings)
    }
    
    /// Returns a new ActionCard with the given InputSlot unbound
    func unbound(slot: InputSlot) -> ActionCard {
        var newInputBindings = inputBindings
        newInputBindings.removeValueForKey(slot)
        return ActionCard(with: self.descriptor, inputBindings: newInputBindings, tokenBindings: self.tokenBindings)
    }
    
    /// Determines if the specified InputSlot has been bound
    func isBound(slot: InputSlot) -> Bool {
        guard let _ = self.inputBindings[slot] else { return false }
        return true
    }
}

//MARK: BindsWithInputCard

extension ActionCard: BindsWithInputCard {
    /// Errors that may occur when binding InputCards
    public enum BindingError: ErrorType {
        /// No free slot of the matching InputType was found
        case NoFreeSlotMatchingInputTypeFound
    }
    
    /// Binds the given InputCard to the first available InputSlot with matching InputType.
    mutating func bind(with card: InputCard) throws {
        for slot in self.descriptor.inputSlots {
            if card.descriptor.inputType == slot.inputType && !self.isBound(slot) {
                self.bind(with: card, in: slot)
                return
            }
        }
        
        throw ActionCard.BindingError.NoFreeSlotMatchingInputTypeFound
    }
    
    /// Returns a new ActionCard with the given InputCard bound to the first free InputSlot with matching InputType.
    func bound(with card: InputCard) throws -> ActionCard {
        for slot in self.descriptor.inputSlots {
            if card.descriptor.inputType == slot.inputType && !self.isBound(slot) {
                var newInputBindings = inputBindings
                newInputBindings[slot] = card
                return ActionCard(with: self.descriptor, inputBindings: newInputBindings, tokenBindings: self.tokenBindings)
            }
        }
        
        throw ActionCard.BindingError.NoFreeSlotMatchingInputTypeFound
    }
    
    /// Binds the given InputCard to the specified InputSlot
    mutating func bind(with card: InputCard, in slot: InputSlot) {
        self.inputBindings[slot] = card
    }
    
    /// Returns a new ActionCard with the given InputCard bound to the specified InputSlot
    func bound(with card: InputCard, in slot: InputSlot) -> ActionCard {
        var newInputBindings = inputBindings
        newInputBindings[slot] = card
        return ActionCard(with: self.descriptor, inputBindings: newInputBindings, tokenBindings: self.tokenBindings)
    }
    
    /// Returns the value held in the specified InputSlot
    func value(of slot: InputSlot) -> InputBinding? {
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
    /// Binds the given TokenCard to the specified TokenSlot
    mutating func bind(with card: TokenCard, in slot: TokenSlot) {
        self.tokenBindings[slot] = card
    }
    
    /// Unbinds the card that was bound to the specified TokenSlot
    mutating func unbind(slot: TokenSlot) {
        self.tokenBindings.removeValueForKey(slot)
    }
    
    /// Returns a new ActionCard with the given TokenCard bound to the specified TokenSlot
    func bound(with card: TokenCard, in slot: TokenSlot) -> ActionCard {
        var newTokenBindings = tokenBindings
        newTokenBindings[slot] = card
        return ActionCard(with: self.descriptor, inputBindings: self.inputBindings, tokenBindings: newTokenBindings)
    }
    
    /// Returns a new ActionCard with the given TokenSlot unbound
    func unbound(slot: TokenSlot) -> ActionCard {
        var newTokenBindings = tokenBindings
        newTokenBindings.removeValueForKey(slot)
        return ActionCard(with: self.descriptor, inputBindings: self.inputBindings, tokenBindings: newTokenBindings)
    }
    
    /// Determines if the specified TokenSlot has been bound
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
            self.bind(with: card, in: slot)
        }
        for (slot, card) in boundActionCards {
            self.bind(with: card, in: slot)
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
