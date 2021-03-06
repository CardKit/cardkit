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
            let duration = try CardKit.Input.Time.Duration <- 5.0
            XCTAssertTrue(duration.boundValue() == 5.0)
        } catch let error {
            XCTFail("\(error)")
        }
    }
    
    func testInputBindingOverwrite() {
        var duration = CardKit.Input.Time.Duration.makeCard()
        do {
            duration = try duration <- 5.0
            duration = try duration <- 2.0
        } catch let error {
            XCTFail("\(error)")
        }
        
        XCTAssertTrue(duration.boundValue() == 2.0)
    }
    
    func testTransitiveBinding() {
        do {
            _ = try CardKit.Action.Trigger.Time.Timer <- (CardKit.Input.Time.Duration <- 5.0)
        } catch let error {
            XCTFail("\(error)")
        }
    }
    
    func testYieldBinding() {
        let a = CKTestCards.Action.YieldingNoAction.makeCard()
        let b = CKTestCards.Action.YieldingNoAction.makeCard()
        
        do {
            guard let firstElementB = b.yields.first else { XCTFail("Missing inputs and/oZ yields, you gots to figure it out")
                return
            }
            let boundA = try a <- (b, firstElementB)
            guard let firstInputSlotA = boundA.inputSlots.first else { XCTFail("Missing Bound A Input Slot")
                return
            }
            XCTAssertTrue(boundA.isSlotBound(firstInputSlotA))
            
            if let binding = boundA.binding(of: firstInputSlotA) {
                if case .boundToYieldingActionCard(let identifier, let yield) = binding {
                    XCTAssertTrue(identifier == b.identifier)
                    XCTAssertTrue(yield.identifier == firstElementB.identifier)
                } else {
                    XCTFail("yield case is not BoundToYieldingActionCard")
                }
            }
            
            
            
        } catch let error {
            XCTFail("\(error)")
        }
    }
    
    func testMultipleInputBinding() {
        let a = CKTestCards.Action.AcceptsMultipleInputTypes.makeCard()
        
        do {
            // the card takes a Real, TextString, Real, RawData, so these values should be bound to slots A and C
            let boundA = try a <- (CardKit.Input.Numeric.Real <- 5.0) <- (CardKit.Input.Numeric.Real <- 3.0)
            
            guard
                let slotA = boundA.inputSlots.slot(named: "A"),
                let slotB = boundA.inputSlots.slot(named: "B"),
                let slotC = boundA.inputSlots.slot(named: "C"),
                let slotD = boundA.inputSlots.slot(named: "D") else {
                    XCTFail("Some Input slots missing")
                    return
            }
            
            XCTAssertTrue(boundA.isSlotBound(slotA))
            XCTAssertFalse(boundA.isSlotBound(slotB))
            XCTAssertTrue(boundA.isSlotBound(slotC))
            XCTAssertFalse(boundA.isSlotBound(slotD))
            
            guard let aValue: Double = boundA.value(of: slotA) else {
                XCTFail("expected a Double value in slotA")
                return
            }
        
            XCTAssertTrue(aValue == 5.0)
        
            guard let cValue: Double = boundA.value(of: slotC) else {
                XCTFail("expected a Double value in slotC")
                return
            }
        
            XCTAssertTrue(cValue == 3.0)
            
        } catch let error {
            XCTFail("\(error)")
        }
    }
    
    func testHandBuilding() {
        let noActionA = CKTestCards.Action.NoAction
        let noActionB = CKTestCards.Action.NoAction
        let hand = noActionA ++ noActionB
        
        // NoActionA, NoActionB, End Rule
        XCTAssertTrue(hand.cardCount == 3)
    }
    
    func testSimpleDeck() {
        let noAction = CKTestCards.Action.NoAction
        
        let deck = (
            noAction ==>
            noAction
            )%
        
        // NoAction, End Rule, NoAction, End Rule
        XCTAssertTrue(deck.cardCount == 4)
    }
    
    func testDeckWithBindings() {
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
            
            XCTAssertTrue(deck.handCount == 3)
            XCTAssertTrue(deck.cardCount == 8)
        } catch let error {
            XCTFail("\(error)")
        }
    }
}
