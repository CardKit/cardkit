//
//  AcceptsInputs.swift
//  CardKit
//
//  Created by Justin Weisz on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

// MARK: AcceptsInputs

/// Applied to card descriptors that accept inputs
protocol AcceptsInputs {
    var inputSlots: [InputSlot] { get }
}
