//
//  DeckTests.swift
//  CardKit
//
//  Created by Justin Weisz on 8/5/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import XCTest

@testable import CardKit

class DeckTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDeckWithSingleDeckCard() {
        let noAction = CKTestCards.Action.NoAction
        
        let deck = (
            noAction ==>
            noAction
            )% + CardKit.Deck.Repeat
        
        // NoAction, End Rule, NoAction, End Rule, Repeat
        XCTAssertTrue(deck.cardCount == 5)
        XCTAssertTrue(deck.deckCards.count == 1)
    }
    
    func testDeckWithMultipleDeckCards() {
        let noAction = CKTestCards.Action.NoAction
        
        let deck = (
            noAction ==>
            noAction
            )% + CardKit.Deck.Repeat + CardKit.Deck.Terminate.makeCard()
        
        // NoAction, End Rule, No Action, End Rule, Repeat, Terminate
        XCTAssertTrue(deck.cardCount == 6)
        XCTAssertTrue(deck.deckCards.count == 2)
    }
    
    func testDeckJSONSerialization() {
        let noAction = CKTestCards.Action.NoAction
        let timer = CardKit.Action.Trigger.Time.Timer
        let wait = CardKit.Action.Trigger.Time.WaitUntilTime
        
        do {
            let deck = try (
                // do nothing
                noAction ==>
                    
                    // wait 5 seconds
                    timer <- (CardKit.Input.Time.Duration <- 5.0)  ==>
                    
                    // wait 10 seconds and until the clock time is reached
                    timer <- (CardKit.Input.Time.Duration <- 10.0)
                    && wait <- (CardKit.Input.Time.ClockTime <- Date())
                )%
            
            let prettyStr = try deck.toJSON().serializeString()
            print("\(prettyStr)")
            
        } catch let error {
            XCTFail("\(error)")
        }
    }
}
