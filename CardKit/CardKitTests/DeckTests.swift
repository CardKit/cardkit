//
//  DeckTests.swift
//  CardKit
//
//  Created by Justin Weisz on 8/5/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import XCTest

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
        let noAction = CardKit.Action.NoAction
        
        let deck = (
            noAction ==>
            noAction
            )% + CardKit.Deck.Repeat
        
        XCTAssertTrue(deck.cardCount == 3)
        XCTAssertTrue(deck.deckCards.count == 1)
    }
    
    func testDeckWithMultipleDeckCards() {
        let noAction = CardKit.Action.NoAction
        
        let deck = (
            noAction ==>
            noAction
            )% + CardKit.Deck.Repeat + CardKit.Deck.Terminate.instance()
        
        XCTAssertTrue(deck.cardCount == 4)
        XCTAssertTrue(deck.deckCards.count == 2)
    }
}
