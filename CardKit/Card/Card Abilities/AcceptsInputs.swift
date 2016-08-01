//
//  AcceptsInputs.swift
//  CardKit
//
//  Created by Justin Weisz on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

//MARK: AcceptsInputs

/// Applied to card descriptors that accept inputs
protocol AcceptsInputs {
    var inputs: [InputCardSlot] { get }
}

/// Applied to card instances that accept inputs
protocol ImplementsAcceptsInputs {
    var inputBindings: [InputCardSlot : ImplementsProducesYields] { get }
    
    func bind(card: ImplementsProducesYields, to slot: InputCardSlot)
    func unbind(slot: InputCardSlot)
    func isBound(slot: InputCardSlot) -> Bool
    func yieldValues(from slot: InputCardSlot) -> [YieldBinding]?
}
