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
    
    // input bindings
    var inputBindings: [InputCardSlot : ImplementsProducesYields] = [:]
    
    // token bindings
    var tokenBindings: [TokenCardSlot : TokenCard] = [:]
    
    // yields
    var yieldData: [Yield : YieldBinding] = [:]
    
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

//MARK:- Card

extension ActionCard: Card {
    // Card protocol
    public var identifier: CardIdentifier { return descriptor.identifier }
    public var description: String { return descriptor.description }
    public var assetCatalog: CardAssetCatalog { return descriptor.assetCatalog }
    public var cardType: CardType { return descriptor.cardType }
}

//MARK:- ImplementsAcceptsInputs

extension ActionCard: ImplementsAcceptsInputs {
    func bind(card: ImplementsProducesYields, to slot: InputCardSlot) {
        // it's not truly necessary to call unbind before doing the
        // re-assignment, but i'm leaving this here just in case
        // bind() / unbind() become more complicated in the future
        // and it becomes necessary.
        if self.isBound(slot) {
            self.unbind(slot)
        }
        
        self.inputBindings[slot] = card
    }
    
    func unbind(slot: InputCardSlot) {
        self.inputBindings.removeValueForKey(slot)
    }
    
    func isBound(slot: InputCardSlot) -> Bool {
        guard let _ = self.inputBindings[slot] else { return false }
        return true
    }
    
    func yieldValues(from slot: InputCardSlot) -> [YieldBinding]? {
        if let card = self.inputBindings[slot] {
            return card.getAllYieldValues()
        } else {
            return nil
        }
    }
}

//MARK:- ImplementsAcceptsTokens

extension ActionCard: ImplementsAcceptsTokens {
    func bind(card: TokenCard, to slot: TokenCardSlot) {
        if self.isBound(slot) {
            self.unbind(slot)
        }
        
        self.tokenBindings[slot] = card
    }
    
    func unbind(slot: TokenCardSlot) {
        self.tokenBindings.removeValueForKey(slot)
    }
    
    func isBound(slot: TokenCardSlot) -> Bool {
        guard let _ = self.tokenBindings[slot] else { return false }
        return true
    }
}

//MARK:- ImplementsProducesYields

extension ActionCard: ImplementsProducesYields {
    func getYieldValue(from yield: Yield) -> YieldBinding? {
        if let data = self.yieldData[yield] {
            return data
        } else {
            return nil
        }
    }
    
    func getAllYieldValues() -> [YieldBinding]? {
        if self.yieldData.count == 0 {
            return nil
        }
        
        return Array(self.yieldData.values)
    }
}
