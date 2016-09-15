//
//  ProducesYields.swift
//  CardKit
//
//  Created by Justin Weisz on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

// MARK: ProducesYields

/// Applied to card descriptors that produce yields
protocol ProducesYields {
    var yields: [Yield] { get }
    var yieldDescription: String { get }
}
