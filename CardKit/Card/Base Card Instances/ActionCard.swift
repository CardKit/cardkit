/**
 * Copyright 2018 IBM Corp. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Foundation

/// ActionCard instances correspond to a specific card contained in a sp
public class ActionCard: Card, Codable {
    public let descriptor: ActionCardDescriptor
    
    // Card protocol
    public fileprivate (set) var identifier: CardIdentifier = CardIdentifier()
    public var cardType: CardType { return descriptor.cardType }
    public var description: String { return descriptor.description }
    public var assetCatalog: CardAssetCatalog { return descriptor.assetCatalog }
    
    // Input bindings
    public fileprivate (set) var inputBindings: [InputSlot: InputSlotBinding] = [:]
    
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
            case .boundToInputCard(let card):
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
            case .boundToYieldingActionCard(let identifier, _):
                identifiers.append(identifier)
            default:
                break
            }
        }
        return identifiers
    }
    
    // token bindings
    public fileprivate (set) var tokenBindings: [TokenSlot: TokenSlotBinding] = [:]
    
    public var tokenSlots: [TokenSlot] {
        return self.descriptor.tokenSlots
    }
    
    public var boundTokenCardIdentifiers: [CardIdentifier] {
        var identifiers: [CardIdentifier] = []
        for binding in self.tokenBindings.values {
            switch binding {
            case .boundToTokenCard(let identifier):
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
    
    init(with descriptor: ActionCardDescriptor, inputBindings: [InputSlot: InputSlotBinding], tokenBindings: [TokenSlot: TokenSlotBinding]) {
        self.descriptor = descriptor
        self.inputBindings = inputBindings
        self.tokenBindings = tokenBindings
    }
}

// MARK: Equatable

extension ActionCard: Equatable {
    static public func == (lhs: ActionCard, rhs: ActionCard) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

// MARK: Hashable

extension ActionCard: Hashable {
    public var hashValue: Int {
        return self.identifier.hashValue
    }
}

// MARK: BindingError

extension ActionCard {
    /// Errors that may occur when binding InputCards and TokenCards
    public enum BindingError: Error {
        /// Attempt to bind the wrong kind of InputCard to a slot (args: expected, provided)
        case inputCardDescriptorMismatchInBinding(InputCardDescriptor, InputCardDescriptor)
        
        /// Attempt to bind the wrong kind of TokenCard to a slot (args: expected, provided)
        case tokenCardDescriptorMismatchInBinding(TokenCardDescriptor, TokenCardDescriptor)
        
        /// No free slot was found for the given InputCard
        case noFreeSlotMatchingInputCardFound
        
        /// No free slot was found where the Yield's YieldType matches the
        /// InputSlot's InputType
        case noFreeSlotMatchingYieldTypeFound
        
        /// No InputSlot found with the given name
        case noInputSlotFoundWithName(String)
        
        /// No TokenSlot found with the given name
        case noTokenSlotFoundWithName(String)
    }
}

// MARK: BindsWithActionCard

extension ActionCard: BindsWithActionCard {
    /// Binds the given ActionCard to the specified InputSlot
    func bind(with card: ActionCard, yield: Yield, in slot: InputSlot) {
        self.inputBindings[slot] = .boundToYieldingActionCard(card.identifier, yield)
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
        
        throw ActionCard.BindingError.noFreeSlotMatchingYieldTypeFound
    }
    
    /// Unbinds the card that was bound to the specified InputSlot
    public func unbind(_ slot: InputSlot) {
        self.inputBindings.removeValue(forKey: slot)
    }
    
    /// Returns a new ActionCard with the given ActionCard bound to the specified InputSlot
    public func bound(with card: ActionCard, yield: Yield, in slot: InputSlot) -> ActionCard {
        var newInputBindings = inputBindings
        newInputBindings[slot] = .boundToYieldingActionCard(card.identifier, yield)
        return ActionCard(with: self.descriptor, inputBindings: newInputBindings, tokenBindings: self.tokenBindings)
    }
    
    /// Returns a new ActionCard with the given ActionCard bound to the first available InputSlot where the
    /// InputCardDescriptor's InputType matches the Yield's YieldType.
    public func bound(with card: ActionCard, yield: Yield) throws -> ActionCard {
        for slot in self.inputSlots {
            if yield.type == slot.descriptor.inputType && !self.isSlotBound(slot) {
                var newInputBindings = inputBindings
                newInputBindings[slot] = .boundToYieldingActionCard(card.identifier, yield)
                return ActionCard(with: self.descriptor, inputBindings: newInputBindings, tokenBindings: self.tokenBindings)
            }
        }
        
        throw ActionCard.BindingError.noFreeSlotMatchingYieldTypeFound
    }
    
    /// Returns a new ActionCard with the given InputSlot unbound
    public func unbound(_ slot: InputSlot) -> ActionCard {
        var newInputBindings = inputBindings
        newInputBindings.removeValue(forKey: slot)
        return ActionCard(with: self.descriptor, inputBindings: newInputBindings, tokenBindings: self.tokenBindings)
    }
    
    /// Determines if the specified InputSlot has been bound
    public func isSlotBound(_ slot: InputSlot) -> Bool {
        guard let binding = self.inputBindings[slot] else { return false }
        if case .unbound = binding {
            return false
        }
        return true
    }
    
    /// Retrieve the binding of the given InputSlot
    public func binding(of slot: InputSlot) -> InputSlotBinding? {
        return self.inputBindings[slot]
    }
}

// MARK: BindsWithInputCard

extension ActionCard: BindsWithInputCard {
    /// Binds the given InputCard to the first available InputSlot with a matching InputCardDescriptor.
    public func bind(with card: InputCard) throws {
        for slot in self.inputSlots {
            if card.descriptor == slot.descriptor && !self.isSlotBound(slot) {
                try self.bind(with: card, in: slot)
                return
            }
        }
        
        throw ActionCard.BindingError.noFreeSlotMatchingInputCardFound
    }
    
    /// Binds the given InputCard to the specified InputSlot
    public func bind(with card: InputCard, in slot: InputSlot) throws {
        if card.descriptor == slot.descriptor {
            self.inputBindings[slot] = .boundToInputCard(card)
        } else {
            throw ActionCard.BindingError.inputCardDescriptorMismatchInBinding(slot.descriptor, card.descriptor)
        }
    }
    
    /// Binds the given InputCard to the given slot
    public func bind(with card: InputCard, inSlotNamed name: String) throws {
        for slot in self.descriptor.inputSlots {
            if slot.name == name {
                try self.bind(with: card, in: slot)
                return
            }
        }
        
        throw ActionCard.BindingError.noInputSlotFoundWithName(name)
    }
    
    /// Returns a new ActionCard with the given InputCard bound to the first free InputSlot 
    /// with matching InputCardDescriptor.
    public func bound(with card: InputCard) throws -> ActionCard {
        for slot in self.inputSlots {
            if card.descriptor == slot.descriptor && !self.isSlotBound(slot) {
                var newInputBindings = inputBindings
                newInputBindings[slot] = .boundToInputCard(card)
                return ActionCard(with: self.descriptor, inputBindings: newInputBindings, tokenBindings: self.tokenBindings)
            }
        }
        
        throw ActionCard.BindingError.noFreeSlotMatchingInputCardFound
    }
    
    /// Returns a new ActionCard with the given InputCard bound to the specified InputSlot
    public func bound(with card: InputCard, in slot: InputSlot) throws -> ActionCard {
        if card.descriptor == slot.descriptor {
            var newInputBindings = inputBindings
            newInputBindings[slot] = .boundToInputCard(card)
            return ActionCard(with: self.descriptor, inputBindings: newInputBindings, tokenBindings: self.tokenBindings)
        } else {
            throw ActionCard.BindingError.inputCardDescriptorMismatchInBinding(slot.descriptor, card.descriptor)
        }
    }
    
    /// Returns a new ActionCard with the given InputCard bound to the slot with the given name
    public func bound(with card: InputCard, inSlotNamed name: String) throws -> ActionCard {
        for slot in self.descriptor.inputSlots {
            if slot.name == name {
                return try self.bound(with: card, in: slot)
            }
        }
        
        throw ActionCard.BindingError.noInputSlotFoundWithName(name)
    }
    
    /// Returns the value held in the specified InputSlot, or nil if the slot is unbound
    /// or if the data cannot be cast to the requested type.
    public func value<T>(of slot: InputSlot) -> T? where T: Codable {
        guard let binding = self.inputBindings[slot] else { return nil }
        if case .boundToInputCard(let card) = binding {
            guard let boundValue: T = card.boundValue() else { return nil }
            return boundValue
        } else {
            return nil
        }
    }
}

// MARK: BindsWithTokenCard

extension ActionCard: BindsWithTokenCard {
    /// Binds the given TokenCard to the specified TokenSlot
    public func bind(with card: TokenCard, in slot: TokenSlot) throws {
        if card.descriptor == slot.descriptor {
            self.tokenBindings[slot] = .boundToTokenCard(card.identifier)
        } else {
            throw ActionCard.BindingError.tokenCardDescriptorMismatchInBinding(slot.descriptor, card.descriptor)
        }
    }
    
    /// Binds the given TokenCard to the given slot
    public func bind(with card: TokenCard, inSlotNamed name: String) throws {
        for slot in self.descriptor.tokenSlots {
            if slot.name == name {
                try self.bind(with: card, in: slot)
                return
            }
        }
        
        throw ActionCard.BindingError.noTokenSlotFoundWithName(name)
    }
    
    /// Unbinds the card that was bound to the specified TokenSlot
    public func unbind(_ slot: TokenSlot) {
        self.tokenBindings.removeValue(forKey: slot)
    }
    
    /// Returns a new ActionCard with the given TokenCard bound to the specified TokenSlot
    public func bound(with card: TokenCard, in slot: TokenSlot) throws -> ActionCard {
        if card.descriptor == slot.descriptor {
            var newTokenBindings = tokenBindings
            newTokenBindings[slot] = .boundToTokenCard(card.identifier)
            return ActionCard(with: self.descriptor, inputBindings: self.inputBindings, tokenBindings: newTokenBindings)
        } else {
            throw ActionCard.BindingError.tokenCardDescriptorMismatchInBinding(slot.descriptor, card.descriptor)
        }
    }
    
    /// Returns a new ActionCard with the given TokenCard bound to the given slot
    public func bound(with card: TokenCard, inSlotNamed name: String) throws -> ActionCard {
        for slot in self.descriptor.tokenSlots {
            if slot.name == name {
                return try self.bound(with: card, in: slot)
            }
        }
        
        throw ActionCard.BindingError.noTokenSlotFoundWithName(name)
    }
    
    /// Returns a new ActionCard with the given TokenSlot unbound
    public func unbound(_ slot: TokenSlot) -> ActionCard {
        var newTokenBindings = tokenBindings
        newTokenBindings.removeValue(forKey: slot)
        return ActionCard(with: self.descriptor, inputBindings: self.inputBindings, tokenBindings: newTokenBindings)
    }
    
    /// Determines if the specified TokenSlot has been bound
    public func isSlotBound(_ slot: TokenSlot) -> Bool {
        guard let binding = self.tokenBindings[slot] else { return false }
        if case .unbound = binding {
            return false
        }
        return true
    }
    
    /// Retrieve the binding of the given TokenSlot
    public func binding(of slot: TokenSlot) -> TokenSlotBinding {
        return self.tokenBindings[slot] ?? .unbound
    }
    
    /// Retrieve the card bound to the given TokenSlot, or nil if no card is bound.
    public func cardIdentifierBound(to slot: TokenSlot) -> CardIdentifier? {
        guard let binding = self.tokenBindings[slot] else { return nil }
        switch binding {
        case .unbound:
            return nil
        case .boundToTokenCard(let identifier):
            return identifier
        }
    }
}
