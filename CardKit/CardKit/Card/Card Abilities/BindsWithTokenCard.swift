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
    mutating func bind(with card: TokenCard, in slot: TokenSlot)
    mutating func unbind(slot: TokenSlot)
    
    func bound(with card: TokenCard, in slot: TokenSlot) -> ActionCard
    func unbound(slot: TokenSlot) -> ActionCard
    func isBound(slot: TokenSlot) -> Bool
}
