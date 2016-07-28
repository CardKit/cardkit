//
//  Consumable.swift
//  CardKit
//
//  Created by Justin Weisz on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

/// Applied to card descriptors that are consumable
protocol Consumable {
    var isConsumable: Bool { get }
}
