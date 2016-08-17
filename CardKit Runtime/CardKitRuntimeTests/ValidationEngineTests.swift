//
//  ValidationEngineTests.swift
//  CardKitRuntime
//
//  Created by Justin Weisz on 8/2/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import XCTest
@testable import CardKit

class ValidationEngineTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testValidationEngineSimple() {
        let noAction = CardKit.Action.NoAction
        
        let deck = (
            noAction ==>
            noAction
            )%
        
        let errors = ValidationEngine.validate(deck)
        
        XCTAssertTrue(errors.count == 0)
    }
}
