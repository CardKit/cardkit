//
//  CardType.swift
//  CardKit
//
//  Created by Justin Weisz on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

public enum CardType: String {
    case action
    case deck
    case hand
    case input
    case token
}

// MARK: Codable

extension CardType: Codable {}
