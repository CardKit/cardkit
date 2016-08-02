//
//  CardKitTests.swift
//  CardKitTests
//
//  Created by Justin Weisz on 7/26/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import XCTest
@testable import CardKit

class CardKitTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDeck() {
        var d: Deck = Deck()
        
        let h1: Hand = Hand()
        let h2: Hand = Hand()
        
        d.hands.append(h1)
        d.hands.append(h2)
        
        print("\(d.toJSON())")
        
        XCTAssertTrue(true)
    }
    
}
