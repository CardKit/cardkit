//
//  HandLogicOperation.swift
//  CardKit
//
//  Created by Justin Weisz on 8/11/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

// MARK: HandLogicOperation

public enum HandLogicOperation: String {
    case indeterminate
    case booleanAnd
    case booleanOr
    case booleanNot
}

// MARK: Codable

extension HandLogicOperation: Codable {}
