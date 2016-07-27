//
//  Card.swift
//  CardKit
//
//  Created by Justin Weisz on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

public class Card {
    var descriptor: CardDescriptor
    
    init(with descriptor: CardDescriptor) {
        self.descriptor = descriptor
    }
}
