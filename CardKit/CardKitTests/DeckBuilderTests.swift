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
    
    func testHandBuilding() {
        let noActionA = CardKit.Action.NoAction
        let noActionB = CardKit.Action.NoAction
        let hand = noActionA + noActionB
        XCTAssertTrue(hand.count == 2)
    }
    
    func testHandLogicBuilding() {
        let noActionA = CardKit.Action.NoAction
        let noActionB = CardKit.Action.NoAction
        let handA = noActionA && noActionB
        let handB = noActionA || noActionB
        let handC = noActionA || !noActionB
        let handD = !noActionA || noActionB
    }
    
    func testSimpleDeck() {
        let noAction = CardKit.Action.NoAction
        
        let deck = (
            noAction ==>
            noAction
            )%
        
        print("deck: \(deck)")
    }
    
    
}
