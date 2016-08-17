//
//  ProducesInput.swift
//  CardKit
//
//  Created by Justin Weisz on 8/2/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

//MARK: ProducesInput

/// Applied to card descriptors that produce input
protocol ProducesInput {
    var inputType: InputType { get }
    var inputDescription: String { get }
}
