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

    func testSimpleDeck() {
        let noAction = CKDescriptors.Action.NoAction
        
        let deck =
            (noAction ==>
            noAction)%
        
        print("deck: \(deck)")
    }

}
