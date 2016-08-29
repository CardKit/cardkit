//
//  BindsWithTokenCard.swift
//  CardKit
//
//  Created by Justin Weisz on 8/2/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

//MARK: BindsWithTokenCard

/// Applied to card instances that accept tokens
protocol BindsWithTokenCard {
    // mutating binds
    mutating func bind(with card: TokenCard, in slot: TokenSlot)
    mutating func bind(with card: TokenCard, inSlotNamed name: TokenSlotName) throws
    mutating func unbind(slot: TokenSlot)
    
    // non-mutating binds
    func bound(with card: TokenCard, in slot: TokenSlot) -> ActionCard
    func bound(with card: TokenCard, inSlotNamed name: TokenSlotName) throws -> ActionCard
    func unbound(slot: TokenSlot) -> ActionCard
    
    // test if a slot is bound
    func isSlotBound(slot: TokenSlot) -> Bool
    
    // retrieve the binding of a slot
    func binding(of slot: TokenSlot) -> TokenSlotBinding
    func cardIdentifierBound(to slot: TokenSlot) -> CardIdentifier?
}
