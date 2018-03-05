//
//  HandEndRule.swift
//  CardKit
//
//  Created by Justin Weisz on 8/9/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

// MARK: HandEndRule

public enum HandEndRule: String {
    case indeterminate
    case endWhenAllSatisfied
    case endWhenAnySatisfied
}

// MARK: Codable

extension HandEndRule: Codable {}
