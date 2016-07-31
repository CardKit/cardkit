//
//  ActionCard.swift
//  CardKit
//
//  Created by Justin Weisz on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

public class ActionCard: Executable {
    public let descriptor: ActionCardDescriptor
    
    init(with descriptor: ActionCardDescriptor) {
        self.descriptor = descriptor
    }
    
    //MARK: InputBindable
    var inputBindings: [InputCardSlot : InputCard] = [:]
    
    //MARK: TokenBindable
    var tokenBindings: [TokenCardSlot : TokenCard] = [:]
    
    //MARK: Executable
    // These cannot be defined in an extension as Swift does not (yet) allow declarations from extensions to be overridden.
    func setup() {
        fatalError("cannot setup() an ActionCard")
    }
    
    func execute() {
        fatalError("cannot execute() an ActionCard")
    }
    
    func interrupt() {
        fatalError("cannot interrupt() an ActionCard")
    }
    
    func teardown() {
        fatalError("cannot teardown() an ActionCard")
    }
}

//MARK: Card

extension ActionCard: Card {
    // Card protocol
    public var identifier: CardIdentifier { return descriptor.identifier }
    public var description: String { return descriptor.description }
    public var assetCatalog: CardAssetCatalog { return descriptor.assetCatalog }
    public var cardType: CardType { return descriptor.cardType }
}

//MARK: ImplementsAcceptsInputs

extension ActionCard: ImplementsAcceptsInputs {
    func bind(card: InputCard, to slot: InputCardSlot) {
        if let _ = self.inputBindings[slot] {
            self.unbind(slot)
        }
        
        self.inputBindings[slot] = card
    }
    
    func unbind(slot: InputCardSlot) {
        self.inputBindings.removeValueForKey(slot)
    }
    
    func valueForInput(slot: InputCardSlot) -> YieldBinding? {
        if let card = self.inputBindings[slot] {
            return card.inputValue
        } else {
            return nil
        }
    }
}

//MARK: ImplementsAcceptsTokens

extension ActionCard: ImplementsAcceptsTokens {
    func bind(card: TokenCard, to slot: TokenCardSlot) {
        if let _ = self.tokenBindings[slot] {
            self.unbind(slot)
        }
        
        self.tokenBindings[slot] = card
    }
    
    func unbind(slot: TokenCardSlot) {
        self.tokenBindings.removeValueForKey(slot)
    }
}
