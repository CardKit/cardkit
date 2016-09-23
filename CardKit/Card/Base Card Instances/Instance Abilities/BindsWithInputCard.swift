//
//  BindsWithInputCard.swift
//  CardKit
//
//  Created by Justin Weisz on 8/2/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy

// MARK: BindsWithInputCard

/// Applied to card instances that bind with Input cards
protocol BindsWithInputCard {
    // mutating binds
    mutating func bind(with card: InputCard) throws
    mutating func bind(with card: InputCard, in slot: InputSlot) throws
    mutating func bind(with card: InputCard, inSlotNamed name: InputSlotName) throws
    mutating func unbind(_ slot: InputSlot)
    
    // non-mutating binds
    func bound(with card: InputCard) throws -> ActionCard
    func bound(with card: InputCard, in slot: InputSlot) throws -> ActionCard
    func bound(with card: InputCard, inSlotNamed name: InputSlotName) throws -> ActionCard
    func unbound(_ slot: InputSlot) -> ActionCard
    
    // test if a slot is bound
    func isSlotBound(_ slot: InputSlot) -> Bool
    
    // retrieve the binding of a slot
    func binding(of slot: InputSlot) -> InputSlotBinding?
    func boundData(of slot: InputSlot) -> InputDataBinding
    func value<T>(of slot: InputSlot) -> T? where T : JSONDecodable
}
