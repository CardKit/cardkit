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
    mutating func bind(with card: ActionCard, in slot: InputSlot)
    mutating func unbind(slot: InputSlot)
    
    func bound(with card: ActionCard, in slot: InputSlot) -> ActionCard
    func unbound(slot: InputSlot) -> ActionCard
    func isBound(slot: InputSlot) -> Bool
}
