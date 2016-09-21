//
//  ArrayExtensions.swift
//  CardKit
//
//  Created by Justin Weisz on 8/3/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

extension Array where Element : Equatable {
    // Remove first collection element that is equal to the given `object`:
    mutating func removeObject(_ object: Iterator.Element) {
        if let index = self.index(of: object) {
            self.remove(at: index)
        }
    }
}
