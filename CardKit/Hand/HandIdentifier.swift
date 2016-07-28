//
//  HandIdentifier.swift
//  CardKit
//
//  Created by Justin Weisz on 7/28/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

/// Hand identifiers are used to uniquely identify hands for branching purposes.
public struct HandIdentifier {
    public let identifier: String
    
    init() {
        identifier = NSUUID().UUIDString
    }
}
