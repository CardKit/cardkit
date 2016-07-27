//
//  Hand.swift
//  CardKit
//
//  Created by Justin Weisz on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

public class Hand {
    var cards: [Card]
    
    init(with cards: [Card]) {
        self.cards = cards
    }
}
