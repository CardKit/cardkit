//
//  Yields.swift
//  CardKit
//
//  Created by Justin Weisz on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

protocol ProducesYields {
    var producesYields: Bool { get }
    var yieldDescription: String { get }
    var yields: [YieldType] { get }
}
