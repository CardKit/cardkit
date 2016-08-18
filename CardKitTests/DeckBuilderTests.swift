//
//  DeckBuilderTests.swift
//  CardKit
//
//  Created by Justin Weisz on 8/3/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import XCTest

class DeckBuilderTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInputBinding() {
        do {
            let duration = try CardKit.Input.Time.Duration <- 5
            XCTAssertTrue(duration.inputDataValue() == 5)
        } catch let error {
            XCTFail("\(error)")
        }
    }
    
    func testInputBindingOverwrite() {
        var duration = CardKit.Input.Time.Duration.makeCard()
        do {
            duration = try duration <- 5
            duration = try duration <- 2
        } catch let error {
            XCTFail("\(error)")
        }
        
        XCTAssertTrue(duration.inputDataValue() == 2)
    }
    
    func testHandBuilding() {
        let noActionA = CardKit.Action.NoAction
        let noActionB = CardKit.Action.NoAction
        let hand = noActionA + noActionB
        
        // NoActionA, NoActionB, End Rule
        XCTAssertTrue(hand.cardCount == 3)
    }
    
    func testTransitiveBinding() {
        do {
            let _ = try (CardKit.Action.Trigger.Time.Timer <- CardKit.Input.Time.Duration <- 5)
        } catch let error {
            XCTFail("\(error)")
        }
    }
    
    func testSimpleDeck() {
        let noAction = CardKit.Action.NoAction
        
        let deck = (
            noAction ==>
            noAction
            )%
        
        // NoAction, End Rule, NoAction, End Rule
        XCTAssertTrue(deck.cardCount == 4)
    }
    
    func testDeckWithBindings() {
        let noAction = CardKit.Action.NoAction
        let timer = CardKit.Action.Trigger.Time.Timer
        let wait = CardKit.Action.Trigger.Time.WaitUntilTime
        
        do {
            let deck = try (
                // do nothing
                noAction ==>
                
                // wait 5 seconds
                timer <- CardKit.Input.Time.Duration <- 5  ==>
                
                // wait 10 seconds and until the clock time is reached
                timer <- CardKit.Input.Time.Duration <- 10
                    && wait <- CardKit.Input.Time.ClockTime <- NSDate()
            )%
            
            XCTAssertTrue(deck.handCount == 3)
            XCTAssertTrue(deck.cardCount == 8)
        } catch let error {
            XCTFail("\(error)")
        }
    }
}
