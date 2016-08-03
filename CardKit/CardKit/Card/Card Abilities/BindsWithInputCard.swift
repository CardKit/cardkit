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
    mutating func bind(with card: InputCard, in slot: InputSlot)
    mutating func bind(with card: InputCard) throws
    mutating func unbind(slot: InputSlot)
    
    func bound(with card: InputCard, in slot: InputSlot) -> ActionCard
    func bound(with card: InputCard) throws -> ActionCard
    func unbound(slot: InputSlot) -> ActionCard
    func isBound(slot: InputSlot) -> Bool
    
    func value(of slot: InputSlot) -> InputBinding?
}
