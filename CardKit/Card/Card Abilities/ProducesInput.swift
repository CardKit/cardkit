//
//  ProducesInputs.swift
//  CardKit
//
//  Created by Justin Weisz on 7/31/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

/// Applied to card descriptors that produce input
protocol ProducesInput {
    var inputType: YieldType { get }
    var inputDescription: String { get }
}

/// Appled to card instances that produce input
protocol ImplementsProducesInput {
    var inputValue: YieldBinding? { get }
}
