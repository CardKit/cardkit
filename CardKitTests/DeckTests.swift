/**
 * Copyright 2018 IBM Corp. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

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
    
    func testDeckSerialization() {
        let noAction = CKTestCards.Action.NoAction
        let timer = CardKit.Action.Trigger.Time.Timer
        let wait = CardKit.Action.Trigger.Time.WaitUntilTime
        
        let encoder = JSONEncoder()
        do {
            let deck = try (
                // do nothing
                noAction ==>
                    
                // wait 5 seconds
                timer <- (CardKit.Input.Time.Duration <- 5.0)  ==>
                
                // wait 10 seconds and until the clock time is reached
                timer <- (CardKit.Input.Time.Duration <- 10.0) &&
                wait <- (CardKit.Input.Time.ClockTime <- Date())
            )%
            
            let str = try encoder.encode(deck)
            print("\(str)")
        } catch let error {
            XCTFail("\(error)")
        }
    }
}
