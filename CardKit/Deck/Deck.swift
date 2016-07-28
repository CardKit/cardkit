//
//  Deck.swift
//  CardKit
//
//  Created by Justin Weisz on 7/28/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

public class Deck {
    public var hands: [HandIdentifier : Hand]
    
    /// Specifies whether execution should loop back to the first hand
    /// or terminate once all the hands have executed
    public var conclusionAction: DeckConclusionAction
    
    /// Keep track of the hand we are currently executing
    private var currentHand: Hand? = nil
    
    init(with hands: [Hand]) {
        self.hands = hands
        self.conclusionAction = .Repeat
    }
}

//MARK: Executable

extension Deck: Executable {
    // Execution is finished when the last hand has finished executing. If there are no hands in the deck, then by definition the deck is finished executing.
    var executionFinished: Bool {
        guard let last = hands.last else { return true }
        return last.executionFinished
    }
    
    func setup() {
        for hand in hands {
            hand.setup()
        }
    }
    
    func execute() {
        for hand in hands {
            hand.execute()
        }
        
        // repeat the deck? or terminate?
        switch conclusionAction {
        case .Repeat:
            // re-setup all the hands
            self.setup()
            
        case .Terminate:
            // terminate
            self.teardown()
        }
    }
    
    func interrupt() {
        for hand in hands {
            hand.interrupt()
        }
    }
    
    func teardown() {
        for hand in hands {
            hand.teardown()
        }
    }
}
