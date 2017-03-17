//
//  InputTests.swift
//  CardKit
//
//  Created by Justin Weisz on 3/17/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import XCTest

import Freddy

@testable import CardKit

class InputTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testEnumerable() {
        XCTAssertTrue(Bool.values.count == 2)
        XCTAssertTrue(Bool.stringValues.count == 2)
        
        // this is a little convoluted to trick the compiler into 
        // not throwing an error that Bool.self is always StringEnumerable.Type
        let types = [Bool.self, Int.self] as [Any]
        var i = 0
        for t in types {
            if t is StringEnumerable.Type {
                XCTAssertTrue(i == 0)
            }
            if !(t is StringEnumerable.Type) {
                XCTAssertTrue(i == 1)
            }
            i += 1
        }
    }
}
