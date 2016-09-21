//
//  AcceptsTokens.swift
//  CardKit
//
//  Created by Justin Weisz on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

// MARK: AcceptsTokens

/// Applied to card descriptors that accept tokens
protocol AcceptsTokens {
    var tokenSlots: [TokenSlot] { get }
}
