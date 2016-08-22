//
//  BindsWithInputCard.swift
//  CardKit
//
//  Created by Justin Weisz on 8/2/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

//MARK: BindsWithInputCard

/// Applied to card instances that bind with Input cards
protocol BindsWithInputCard {
    // mutating binds
    mutating func bind(with card: InputCard, in slot: InputSlot)
    mutating func bind(with card: InputCard) throws
    mutating func unbind(slot: InputSlot)
    
    // non-mutating binds
    func bound(with card: InputCard, in slot: InputSlot) -> ActionCard
    func bound(with card: InputCard) throws -> ActionCard
    func unbound(slot: InputSlot) -> ActionCard
    
    // test if a slot is bound
    func isSlotBound(slot: InputSlot) -> Bool
    
    // retrieve the binding of a slot
    func binding(of slot: InputSlot) -> InputSlotBinding?
    func value(of slot: InputSlot) -> InputDataBinding
}