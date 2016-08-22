//
//  BindsWithActionCard.swift
//  CardKit
//
//  Created by Justin Weisz on 8/2/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

//MARK: BindsWithActionCard

/// Applied to card instances that bind with Action cards (i.e. bind to their yield values)
protocol BindsWithActionCard {
    // mutating binds
    mutating func bind(with card: ActionCard, yield: Yield, in slot: InputSlot)
    mutating func unbind(slot: InputSlot)
    
    // non-mutating binds
    func bound(with card: ActionCard, yield: Yield, in slot: InputSlot) -> ActionCard
    func unbound(slot: InputSlot) -> ActionCard
    
    // test if a slot is bound
    func isSlotBound(slot: InputSlot) -> Bool
    
    // retrieve the binding of the slot
    func binding(of slot: InputSlot) -> InputSlotBinding?
}