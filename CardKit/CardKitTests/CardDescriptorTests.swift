//
//  CardDescriptorTests.swift
//  CardKit
//
//  Created by Justin Weisz on 8/3/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import XCTest

class CardDescriptorTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDescriptorJSON() {
        let noAction = CKDescriptors.Action.NoAction
        print("description: \(noAction.description)")
        print("json: \(noAction.toJSON())")
    }
}
