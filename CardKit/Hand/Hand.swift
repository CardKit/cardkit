//
//  Hand.swift
//  CardKit
//
//  Created by Justin Weisz on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

public class Hand {
    public var cards: [Card]
    
    public let identifier: HandIdentifier
    
    init(with cards: [Card]) {
        self.cards = cards
        self.identifier = HandIdentifier()
    }
}

//MARK: Executable

extension Hand: Executable {
    var executionFinished: Bool {
        get {
            var finished = false
            for card in cards {
                if let executable = card as? Executable {
                    finished = finished && executable.executionFinished
                }
            }
            return finished
        }
    }
    
    func setup() {
        for card in cards {
            if let executable = card as? Executable {
                executable.setup()
            }
        }
    }
    
    func execute() {
        for card in cards {
            if let executable = card as? Executable {
                executable.execute()
            }
        }
    }
    
    func interrupt() {
        for card in cards {
            if let executable = card as? Executable {
                executable.interrupt()
            }
        }
    }
    
    func teardown() {
        for card in cards {
            if let executable = card as? Executable {
                executable.teardown()
            }
        }
    }
}
