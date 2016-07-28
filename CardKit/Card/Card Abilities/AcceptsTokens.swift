//
//  AcceptsTokens.swift
//  CardKit
//
//  Created by Justin Weisz on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

public typealias CardTokens = [String: TokenCardDescriptor]

/// Applied to card descriptors that accept tokens
protocol AcceptsTokens {
    var tokens: CardTokens { get }
}
