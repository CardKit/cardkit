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
    mutating func bind(card: ActionCard, to slot: InputSlot)
    mutating func unbind(slot: InputSlot)
    func isBound(slot: InputSlot) -> Bool
}
