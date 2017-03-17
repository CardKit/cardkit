//
//  CKInputTypes.swift
//  CardKit
//
//  Created by ismails on 3/14/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation
import Freddy

extension Bool: Enumerable {
    public static var values: [Bool] {
        return [false, true]
    }
}

extension Bool: StringEnumerable {
    public static var stringValues: [String] {
        return ["False", "True"]
    }
}
