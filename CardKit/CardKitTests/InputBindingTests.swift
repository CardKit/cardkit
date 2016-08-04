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
        var angle = CardKit.Input.Location.Angle.instance()
        
        do {
            try angle.bind(withValue: 1.0)
        } catch let error {
            XCTFail("error binding double value to Angle card: \(error)")
        }
        
        XCTAssertTrue(angle.inputDataValue() == 1.0)
    }
    
    func testValidNSDataBinding() {
        var image = CardKit.Input.Media.Image.instance()
        
        let str = "Hello, world"
        let data = str.dataUsingEncoding(NSUTF8StringEncoding)
        
        do {
            try image.bind(withValue: data!)
        } catch let error {
            XCTFail("error binding double value to Angle card: \(error)")
        }
        
        let boundData: NSData = image.inputDataValue()!
        let boundStr: String = String(data: boundData, encoding: NSUTF8StringEncoding)!
        
        XCTAssertTrue(boundStr == str)
    }
    
    func testValidStructBinding() {
        var bb = CardKit.Input.Location.BoundingBox.instance()
        
        let topLeft = InputCoordinate2D(latitude: 0.0, longitude: 0.0)
        let topRight = InputCoordinate2D(latitude: 0.0, longitude: 1.0)
        let botLeft = InputCoordinate2D(latitude: 1.0, longitude: 0.0)
        let botRight = InputCoordinate2D(latitude: 1.0, longitude: 1.0)
        
        let box: [InputCoordinate2D] = [topLeft, topRight, botLeft, botRight]
        
        do {
            try bb.bind(withValue: box)
        } catch let error {
            XCTFail("error binding double value to Angle card: \(error)")
        }
        
        let bbBox: [InputCoordinate2D] = bb.inputDataValue()!
        XCTAssertTrue(bbBox == box)
    }
    
    func testTypeMismatchBinding() {
        var integer = CardKit.Input.Numeric.Integer.instance()
        
        do {
            try integer.bind(withValue: 1.0)
            XCTFail("attempt to bind Double to Int shouldn't have succeeded")
        } catch {
            XCTAssertTrue(integer.isBound() == false)
        }
    }
}
