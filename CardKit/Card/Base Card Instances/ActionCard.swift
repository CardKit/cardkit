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
        return self.descriptor.tokenSlots
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
            guard let slot = self.inputSlots.slot(named: slotName) else {
                throw JSON.Error.ValueNotConvertible(value: json, to: ActionCard.self)
            }
            
            // bind it
            self.inputBindings[slot] = binding
        }
        
        self.tokenBindings = [:]
        let jsonTokenBindings: [String : TokenSlotBinding] = try json.dictionary("tokenBindings").withDecodedValues()
        for (slotName, binding) in jsonTokenBindings {
            // find the TokenSlot
            guard let slot = self.descriptor.tokenSlots.slot(named: slotName) else {
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
            jsonTokenBindings[slot.name] = binding
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
        /// Attempt to bind the wrong kind of InputCard to a slot (args: expected, provided)
        case InputCardDescriptorMismatchInBinding(InputCardDescriptor, InputCardDescriptor)
        
        /// Attempt to bind the wrong kind of TokenCard to a slot (args: expected, provided)
        case TokenCardDescriptorMismatchInBinding(TokenCardDescriptor, TokenCardDescriptor)
        
        /// No free slot was found for the given InputCard
        case NoFreeSlotMatchingInputCardFound
        
        /// No free slot was found where the Yield's YieldType matches the
        /// InputSlot's InputType
        case NoFreeSlotMatchingYieldTypeFound
        
        /// No InputSlot found with the given TokenSlotName
        case NoInputSlotFoundWithName(InputSlotName)
        
        /// No TokenSlot found with the given TokenSlotName
        case NoTokenSlotFoundWithName(TokenSlotName)
    }
}

//MARK: BindsWithActionCard

extension ActionCard: BindsWithActionCard {
    /// Binds the given ActionCard to the specified InputSlot
    func bind(with card: ActionCard, yield: Yield, in slot: InputSlot) {
        self.inputBindings[slot] = .BoundToYieldingActionCard(card.identifier, yield)
    }
    
    /// Binds the given ActionCard to the first available InputSlot where the InputCardDescriptor's
    /// InputType matches the Yield's YieldType.
    func bind(with card: ActionCard, yield: Yield) throws {
        for slot in self.inputSlots {
            if yield.type == slot.descriptor.inputType && !self.isSlotBound(slot) {
                self.bind(with: card, yield: yield, in: slot)
                return
            }
        }
        
        throw ActionCard.BindingError.NoFreeSlotMatchingYieldTypeFound
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
    
    /// Returns a new ActionCard with the given ActionCard bound to the first available InputSlot where the
    /// InputCardDescriptor's InputType matches the Yield's YieldType.
    func bound(with card: ActionCard, yield: Yield) throws -> ActionCard {
        for slot in self.inputSlots {
            if yield.type == slot.descriptor.inputType && !self.isSlotBound(slot) {
                var newInputBindings = inputBindings
                newInputBindings[slot] = .BoundToYieldingActionCard(card.identifier, yield)
                return ActionCard(with: self.descriptor, inputBindings: newInputBindings, tokenBindings: self.tokenBindings)
            }
        }
        
        throw ActionCard.BindingError.NoFreeSlotMatchingYieldTypeFound
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
        return self.inputBindings[slot]
    }
}

//MARK: BindsWithInputCard

extension ActionCard: BindsWithInputCard {
    /// Binds the given InputCard to the first available InputSlot with a matching InputCardDescriptor.
    func bind(with card: InputCard) throws {
        for slot in self.inputSlots {
            if card.descriptor == slot.descriptor && !self.isSlotBound(slot) {
                try self.bind(with: card, in: slot)
                return
            }
        }
        
        throw ActionCard.BindingError.NoFreeSlotMatchingInputCardFound
    }
    
    /// Binds the given InputCard to the specified InputSlot
    func bind(with card: InputCard, in slot: InputSlot) throws {
        if card.descriptor == slot.descriptor {
            self.inputBindings[slot] = .BoundToInputCard(card)
        } else {
            throw ActionCard.BindingError.InputCardDescriptorMismatchInBinding(slot.descriptor, card.descriptor)
        }
    }
    
    /// Binds the given InputCard to slot with the given InputSlotName
    func bind(with card: InputCard, inSlotNamed name: InputSlotName) throws {
        for slot in self.descriptor.inputSlots {
            if slot.name == name {
                try self.bind(with: card, in: slot)
                return
            }
        }
        
        throw ActionCard.BindingError.NoInputSlotFoundWithName(name)
    }
    
    /// Returns a new ActionCard with the given InputCard bound to the first free InputSlot 
    /// with matching InputCardDescriptor.
    func bound(with card: InputCard) throws -> ActionCard {
        for slot in self.inputSlots {
            if card.descriptor == slot.descriptor && !self.isSlotBound(slot) {
                var newInputBindings = inputBindings
                newInputBindings[slot] = .BoundToInputCard(card)
                return ActionCard(with: self.descriptor, inputBindings: newInputBindings, tokenBindings: self.tokenBindings)
            }
        }
        
        throw ActionCard.BindingError.NoFreeSlotMatchingInputCardFound
    }
    
    /// Returns a new ActionCard with the given InputCard bound to the specified InputSlot
    func bound(with card: InputCard, in slot: InputSlot) throws -> ActionCard {
        if card.descriptor == slot.descriptor {
            var newInputBindings = inputBindings
            newInputBindings[slot] = .BoundToInputCard(card)
            return ActionCard(with: self.descriptor, inputBindings: newInputBindings, tokenBindings: self.tokenBindings)
        } else {
            throw ActionCard.BindingError.InputCardDescriptorMismatchInBinding(slot.descriptor, card.descriptor)
        }
    }
    
    /// Returns a new ActionCard with the given InputCard bound to the slot with the given InputSlotName
    func bound(with card: InputCard, inSlotNamed name: TokenSlotName) throws -> ActionCard {
        for slot in self.descriptor.inputSlots {
            if slot.name == name {
                return try self.bound(with: card, in: slot)
            }
        }
        
        throw ActionCard.BindingError.NoInputSlotFoundWithName(name)
    }
    
    /// Returns the InputDataBinding held in the specified InputSlot, or .Unbound if the
    /// slot is not bound.
    public func boundData(of slot: InputSlot) -> InputDataBinding {
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
    
    /// Returns the raw value held in the specified InputSlot, or nil
    /// if the slot is unbound or if the data cannot be cast to the requested
    /// type.
    public func value<T>(of slot: InputSlot) -> T? {
        guard let binding = self.inputBindings[slot] else { return nil }
        switch binding {
        case .BoundToInputCard(let card):
            switch card.boundData {
            case .SwiftInt(let val):
                return val as? T
            case .SwiftDouble(let val):
                return val as? T
            case .SwiftString(let val):
                return val as? T
            case .SwiftData(let val):
                return val as? T
            case .SwiftDate(let val):
                return val as? T
            case .Coordinate2D(let val):
                return val as? T
            case .Coordinate2DPath(let val):
                return val as? T
            case .Coordinate3D(let val):
                return val as? T
            case .Coordinate3DPath(let val):
                return val as? T
            case .CardinalDirection(let val):
                return val as? T
            default:
                return nil
            }
        default:
            return nil
        }
    }
}

//MARK: BindsWithTokenCard

extension ActionCard: BindsWithTokenCard {
    /// Binds the given TokenCard to the specified TokenSlot
    func bind(with card: TokenCard, in slot: TokenSlot) throws {
        if card.descriptor == slot.descriptor {
            self.tokenBindings[slot] = .BoundToTokenCard(card.identifier)
        } else {
            throw ActionCard.BindingError.TokenCardDescriptorMismatchInBinding(slot.descriptor, card.descriptor)
        }
    }
    
    /// Binds the given TokenCard to slot with the given TokenSlotName
    func bind(with card: TokenCard, inSlotNamed name: TokenSlotName) throws {
        for slot in self.descriptor.tokenSlots {
            if slot.name == name {
                try self.bind(with: card, in: slot)
                return
            }
        }
        
        throw ActionCard.BindingError.NoTokenSlotFoundWithName(name)
    }
    
    /// Unbinds the card that was bound to the specified TokenSlot
    func unbind(slot: TokenSlot) {
        self.tokenBindings.removeValueForKey(slot)
    }
    
    /// Returns a new ActionCard with the given TokenCard bound to the specified TokenSlot
    func bound(with card: TokenCard, in slot: TokenSlot) throws -> ActionCard {
        if card.descriptor == slot.descriptor {
            var newTokenBindings = tokenBindings
            newTokenBindings[slot] = .BoundToTokenCard(card.identifier)
            return ActionCard(with: self.descriptor, inputBindings: self.inputBindings, tokenBindings: newTokenBindings)
        } else {
            throw ActionCard.BindingError.TokenCardDescriptorMismatchInBinding(slot.descriptor, card.descriptor)
        }
    }
    
    /// Returns a new ActionCard with the given TokenCard bound to the slot with the given TokenSlotName
    func bound(with card: TokenCard, inSlotNamed name: TokenSlotName) throws -> ActionCard {
        for slot in self.descriptor.tokenSlots {
            if slot.name == name {
                return try self.bound(with: card, in: slot)
            }
        }
        
        throw ActionCard.BindingError.NoTokenSlotFoundWithName(name)
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
