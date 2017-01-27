//
//  Satisfiable.swift
//  CardKit
//
//  Created by Justin Weisz on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

// MARK: Satisfiable

/// Applied to card descriptors that are satisfiable
protocol Satisfiable {
    var ends: Bool { get }
    var endDescription: String { get }
}
