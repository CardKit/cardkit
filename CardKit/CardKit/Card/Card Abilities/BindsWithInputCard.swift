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
    mutating func bind(card: InputCard, to slot: InputSlot)
    mutating func unbind(slot: InputSlot)
    func isBound(slot: InputSlot) -> Bool
    func inputValue(of slot: InputSlot) -> InputBinding?
}
