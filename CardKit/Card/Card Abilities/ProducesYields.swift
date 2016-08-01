//
//  Yields.swift
//  CardKit
//
//  Created by Justin Weisz on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

/// Applied to card descriptors that produce yields
protocol ProducesYields {
    var yields: [Yield] { get }
    var yieldDescription: String { get }
}

/// Applied to card instances that produce yields
protocol ImplementsProducesYields {
    func getYieldValue(from yield: Yield) -> YieldBinding?
    func getAllYieldValues() -> [YieldBinding]?
}
