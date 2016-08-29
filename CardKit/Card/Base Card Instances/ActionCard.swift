//
//  ActionCard.swift
//  CardKit
//
//  Created by Justin Weisz on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy

public class ActionCard: Card, JSONEncodable, JSONDecodable {
    public let descriptor: ActionCardDescriptor
    
    // Card protocol
    public private (set) var identifier: CardIdentifier = CardIdentifier()
    public var cardType: CardType { return descriptor.cardType }
    public var description: String { return descriptor.description }
    public var assetCatalog: CardAssetCatalog { return descriptor.assetCatalog }
    
    // Input bindings
    public private (set) var inputBindings: [InputSlot : InputSlotBinding] = [:]
    
    // Exposed from the descriptor
    public var inputSlots: [InputSlot] {
        return self.descriptor.inputSlots
    }
    
    public var yields: [Yield] {
        return self.descriptor.yields
    }
    
    /// Returns the InputCards bound to us.
    public var boundInputCards: [InputCard] {
        var cards: [InputCard] = []
        for binding in self.inputBindings.values {
            switch binding {
            case .BoundToInputCard(let card):
                cards.append(card)
            default:
                break
            }
        }
        return cards
    }
    
    /// Returns the CardIdentifiers of the ActionCards whose Yields we are using.
    public var boundActionCardIdentifiers: [CardIdentifier] {
        var identifiers: [CardIdentifier] = []
        for binding in self.inputBindings.values {
            switch binding {
            case .BoundToYieldingActionCard(let identifier, _):
                identifiers.append(identifier)
            default:
                break
            }
        }
        return identifiers
    }
    
    // token bindings
    public private (set) var tokenBindings: [TokenSlot : TokenSlotBinding] = [:]
    
    public var tokenSlots: [TokenSlot] {
        return Array(self.tokenBindings.keys)
    }
    
    public var boundTokenCardIdentifiers: [CardIdentifier] {
        var identifiers: [CardIdentifier] = []
        for binding in self.tokenBindings.values {
            switch binding {
            case .BoundToTokenCard(let identifier):
                identifiers.append(identifier)
            default:
                break
            }
        }
        return identifiers
    }
    
    init(with descriptor: ActionCardDescriptor) {
        self.descriptor = descriptor
    }
    
    init(with descriptor: ActionCardDescriptor, inputBindings: [InputSlot : InputSlotBinding], tokenBindings: [TokenSlot : TokenSlotBinding]) {
        self.descriptor = descriptor
        self.inputBindings = inputBindings
        self.tokenBindings = tokenBindings
    }
    
    //MARK: JSONEncodable & JSONDecodable
    
    public required init(json: JSON) throws {
        self.identifier = try json.decode("identifier", type: CardIdentifier.self)
        self.descriptor = try json.decode("descriptor", type: ActionCardDescriptor.self)
        
        self.inputBindings = [:]
        let jsonInputBindings: [String : InputSlotBinding] = try json.dictionary("inputBindings").withDecodedValues()
        for (slotName, binding) in jsonInputBindings {
            // find the InputSlot
            guard let slot = self.descriptor.inputSlots.slot(named: slotName) else {
                throw JSON.Error.ValueNotConvertible(value: json, to: ActionCard.self)
            }
            
            // bind it
            self.inputBindings[slot] = binding
        }
        
        self.tokenBindings = [:]
        let jsonTokenBindings: [String : TokenSlotBinding] = try json.dictionary("tokenBindings").withDecodedValues()
        for (identifier, binding) in jsonTokenBindings {
            // find the TokenSlot
            guard let slot = self.descriptor.tokenSlots.slot(with: identifier) else {
                throw JSON.Error.ValueNotConvertible(value: json, to: ActionCard.self)
            }
            
            // bind it
            self.tokenBindings[slot] = binding
        }
    }
    
    public func toJSON() -> JSON {
        // need to treat inputBindings and tokenBindings special. we can't just rely on
        // self.inputBindings.toJSON() because Freddy will use String(InputSlot) to create
        // the string values for the dictionary keys. which means our keys will end up looking
        // like this, which is impossible to decode:
        //   InputSlot(name: \"Duration\", inputType: CardKitTests_iOS.InputType.SwiftInt, isOptional: false)
        // instead, we will use the *name* of the slot as the key, and when we deserialize, we will restore
        // the original mapping back to the actual InputSlot object.
        
        var jsonInputBindings: [String : InputSlotBinding] = [:]
        for (slot, binding) in self.inputBindings {
            jsonInputBindings[slot.name] = binding
        }
        
        var jsonTokenBindings: [String : TokenSlotBinding] = [:]
        for (slot, binding) in self.tokenBindings {
            jsonTokenBindings[slot.identifier] = binding
        }
        
        return .Dictionary([
            "identifier": self.identifier.toJSON(),
            "descriptor": self.descriptor.toJSON(),
            "inputBindings": jsonInputBindings.toJSON(),
            "tokenBindings": jsonTokenBindings.toJSON()
            ])
    }
}

//MARK: Equatable

extension ActionCard: Equatable {}

public func == (lhs: ActionCard, rhs: ActionCard) -> Bool {
    return lhs.identifier == rhs.identifier
}

//MARK: Hashable

extension ActionCard: Hashable {
    public var hashValue: Int {
        return self.identifier.hashValue
    }
}

//MARK: BindingError

extension ActionCard {
    /// Errors that may occur when binding InputCards and TokenCards
    public enum BindingError: ErrorType {
        /// No free slot of the matching InputType was found
        case NoFreeSlotMatchingInputTypeFound
        
        /// No TokenSlot found with the given TokenIdentifier
        case NoTokenSlotFoundWithIdentifier
    }
}

//MARK: BindsWithActionCard

extension ActionCard: BindsWithActionCard {
    /// Binds the given ActionCard to the specified InputSlot
    func bind(with card: ActionCard, yield: Yield, in slot: InputSlot) {
        self.inputBindings[slot] = .BoundToYieldingActionCard(card.identifier, yield)
    }
    
    /// Unbinds the card that was bound to the specified InputSlot
    func unbind(slot: InputSlot) {
        self.inputBindings.removeValueForKey(slot)
    }
    
    /// Returns a new ActionCard with the given ActionCard bound to the specified InputSlot
    func bound(with card: ActionCard, yield: Yield, in slot: InputSlot) -> ActionCard {
        var newInputBindings = inputBindings
        newInputBindings[slot] = .BoundToYieldingActionCard(card.identifier, yield)
        return ActionCard(with: self.descriptor, inputBindings: newInputBindings, tokenBindings: self.tokenBindings)
    }
    
    /// Returns a new ActionCard with the given InputSlot unbound
    func unbound(slot: InputSlot) -> ActionCard {
        var newInputBindings = inputBindings
        newInputBindings.removeValueForKey(slot)
        return ActionCard(with: self.descriptor, inputBindings: newInputBindings, tokenBindings: self.tokenBindings)
    }
    
    /// Determines if the specified InputSlot has been bound
    public func isSlotBound(slot: InputSlot) -> Bool {
        guard let binding = self.inputBindings[slot] else { return false }
        if case .Unbound = binding {
            return false
        }
        return true
    }
    
    /// Retrieve the binding of the given InputSlot
    public func binding(of slot: InputSlot) -> InputSlotBinding? {
        return self.inputBindings[slot] ?? nil
    }
}

//MARK: BindsWithInputCard

extension ActionCard: BindsWithInputCard {
    /// Binds the given InputCard to the first available InputSlot with matching InputType.
    func bind(with card: InputCard) throws {
        for slot in self.descriptor.inputSlots {
            if card.descriptor.inputType == slot.inputType && !self.isSlotBound(slot) {
                self.bind(with: card, in: slot)
                return
            }
        }
        
        throw ActionCard.BindingError.NoFreeSlotMatchingInputTypeFound
    }
    
    /// Returns a new ActionCard with the given InputCard bound to the first free InputSlot with matching InputType.
    func bound(with card: InputCard) throws -> ActionCard {
        for slot in self.descriptor.inputSlots {
            if card.descriptor.inputType == slot.inputType && !self.isSlotBound(slot) {
                var newInputBindings = inputBindings
                newInputBindings[slot] = .BoundToInputCard(card)
                return ActionCard(with: self.descriptor, inputBindings: newInputBindings, tokenBindings: self.tokenBindings)
            }
        }
        
        throw ActionCard.BindingError.NoFreeSlotMatchingInputTypeFound
    }
    
    /// Binds the given InputCard to the specified InputSlot
    func bind(with card: InputCard, in slot: InputSlot) {
        self.inputBindings[slot] = .BoundToInputCard(card)
    }
    
    /// Returns a new ActionCard with the given InputCard bound to the specified InputSlot
    func bound(with card: InputCard, in slot: InputSlot) -> ActionCard {
        var newInputBindings = inputBindings
        newInputBindings[slot] = .BoundToInputCard(card)
        return ActionCard(with: self.descriptor, inputBindings: newInputBindings, tokenBindings: self.tokenBindings)
    }
    
    /// Returns the value held in the specified InputSlot
    public func value(of slot: InputSlot) -> InputDataBinding {
        guard let binding = self.inputBindings[slot] else { return .Unbound }
        
        switch binding {
        case .Unbound:
            return .Unbound
        case .BoundToInputCard(let card):
            return card.boundData
        case .BoundToYieldingActionCard(_):
            return .Unbound
        }
    }
}

//MARK: BindsWithTokenCard

extension ActionCard: BindsWithTokenCard {
    /// Binds the given TokenCard to the specified TokenSlot
    func bind(with card: TokenCard, in slot: TokenSlot) {
        self.tokenBindings[slot] = .BoundToTokenCard(card.identifier)
    }
    
    /// Binds the given TokenCard to slot with the given TokenIdentifier
    func bind(with card: TokenCard, toSlotWithIdentifier identifier: TokenIdentifier) throws {
        for slot in self.descriptor.tokenSlots {
            if slot.identifier == identifier {
                self.bind(with: card, in: slot)
                return
            }
        }
        
        throw ActionCard.BindingError.NoTokenSlotFoundWithIdentifier
    }
    
    /// Unbinds the card that was bound to the specified TokenSlot
    func unbind(slot: TokenSlot) {
        self.tokenBindings.removeValueForKey(slot)
    }
    
    /// Returns a new ActionCard with the given TokenCard bound to the specified TokenSlot
    func bound(with card: TokenCard, in slot: TokenSlot) -> ActionCard {
        var newTokenBindings = tokenBindings
        newTokenBindings[slot] = .BoundToTokenCard(card.identifier)
        return ActionCard(with: self.descriptor, inputBindings: self.inputBindings, tokenBindings: newTokenBindings)
    }
    
    /// Returns a new ActionCard with the given TokenCard bound to the slot with the given TokenIdentifier
    func bound(with card: TokenCard, toSlotWithIdentifier identifier: TokenIdentifier) throws -> ActionCard {
        for slot in self.descriptor.tokenSlots {
            if slot.identifier == identifier {
                return self.bound(with: card, in: slot)
            }
        }
        
        throw ActionCard.BindingError.NoTokenSlotFoundWithIdentifier
    }
    
    /// Returns a new ActionCard with the given TokenSlot unbound
    func unbound(slot: TokenSlot) -> ActionCard {
        var newTokenBindings = tokenBindings
        newTokenBindings.removeValueForKey(slot)
        return ActionCard(with: self.descriptor, inputBindings: self.inputBindings, tokenBindings: newTokenBindings)
    }
    
    /// Determines if the specified TokenSlot has been bound
    public func isSlotBound(slot: TokenSlot) -> Bool {
        guard let binding = self.tokenBindings[slot] else { return false }
        if case .Unbound = binding {
            return false
        }
        return true
    }
    
    /// Retrieve the binding of the given TokenSlot
    public func binding(of slot: TokenSlot) -> TokenSlotBinding {
        return self.tokenBindings[slot] ?? .Unbound
    }
    
    /// Retrieve the card bound to the given TokenSlot, or nil if no card is bound.
    public func cardIdentifierBound(to slot: TokenSlot) -> CardIdentifier? {
        guard let binding = self.tokenBindings[slot] else { return nil }
        switch binding {
        case .Unbound:
            return nil
        case .BoundToTokenCard(let identifier):
            return identifier
        }
    }
}
