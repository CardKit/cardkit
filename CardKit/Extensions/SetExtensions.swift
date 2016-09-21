//
//  SetExtensions.swift
//  CardKit
//
//  Created by Justin Weisz on 8/5/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

extension Set {
    mutating func insertAll(_ objects: [Set.Element]) {
        for item in objects {
            self.insert(item)
        }
    }
}
