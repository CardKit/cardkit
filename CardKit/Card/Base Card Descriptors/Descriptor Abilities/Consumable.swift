//
//  Consumable.swift
//  CardKit
//
//  Created by Justin Weisz on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

// MARK: Consumable

/// Applied to card descriptors that are consumed
protocol Consumable {
    var isConsumed: Bool { get }
}
