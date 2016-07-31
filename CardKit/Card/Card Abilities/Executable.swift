//
//  Executable.swift
//  CardKit
//
//  Created by Justin Weisz on 7/28/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

/// Appled to card instances that are executable
protocol Executable {
    func setup()
    func execute()
    func interrupt()
    func teardown()
}
