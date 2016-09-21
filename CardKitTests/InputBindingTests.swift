//
//  InputBindingTests.swift
//  CardKit
//
//  Created by Justin Weisz on 8/4/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import XCTest

class InputBindingTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testValidDoubleBinding() {
        let angle = CardKit.Input.Location.Angle.makeCard()
        
        do {
            try angle.bind(withValue: 1.0)
        } catch let error {
            XCTFail("error binding double value to Angle card: \(error)")
        }
        
        XCTAssertTrue(angle.inputDataValue() == 1.0)
    }
    
    func testValidDataBinding() {
        let image = CardKit.Input.Media.Image.makeCard()
        
        let str = "Hello, world"
        let data = str.data(using: String.Encoding.utf8)
        
        do {
            try image.bind(withValue: data!)
        } catch let error {
            XCTFail("error binding double value to Angle card: \(error)")
        }
        
        let boundData: Data = image.inputDataValue()!
        let boundStr: String = String(data: boundData, encoding: String.Encoding.utf8)!
        
        XCTAssertTrue(boundStr == str)
    }
    
    func testValidStructBinding() {
        let bb = CardKit.Input.Location.BoundingBox.makeCard()
        
        let topLeft = CKCoordinate2D(latitude: 0.0, longitude: 0.0)
        let topRight = CKCoordinate2D(latitude: 0.0, longitude: 1.0)
        let botLeft = CKCoordinate2D(latitude: 1.0, longitude: 0.0)
        let botRight = CKCoordinate2D(latitude: 1.0, longitude: 1.0)
        
        let box: [CKCoordinate2D] = [topLeft, topRight, botLeft, botRight]
        
        do {
            try bb.bind(withValue: box)
        } catch let error {
            XCTFail("error binding double value to Angle card: \(error)")
        }
        
        let bbBox: [CKCoordinate2D] = bb.inputDataValue()!
        XCTAssertTrue(bbBox == box)
    }
    
    func testTypeMismatchBinding() {
        let integer = CardKit.Input.Numeric.Integer.makeCard()
        
        do {
            try integer.bind(withValue: 1.0)
            XCTFail("attempt to bind Double to Int shouldn't have succeeded")
        } catch {
            XCTAssertTrue(integer.isBound() == false)
        }
    }
}
