//
//  InputBindingTests.swift
//  CardKit
//
//  Created by Justin Weisz on 8/4/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import XCTest

@testable import CardKit

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
        let card = CardKit.Input.Numeric.Real.makeCard()
        
        do {
            try card.bind(withValue: 1.0)
        } catch let error {
            XCTFail("error binding double value to Real card: \(error)")
        }
        
        XCTAssertTrue(card.boundValue() == 1.0)
    }
    
    func testValidDataBinding() {
        let image = CardKit.Input.Media.Image.makeCard()
        
        let str = "Hello, world"
        guard let data = str.data(using: String.Encoding.utf8) else {
            XCTFail("could not convert String to Data")
            return
        }
        
        do {
            try image.bind(withValue: data)
        } catch let error {
            XCTFail("error binding Data value to Image card: \(error)")
            return
        }
        
        guard let boundData: Data = image.boundValue() else {
            XCTFail("boundData should not be nil")
            return
        }
        
        guard let boundStr: String = String(data: boundData, encoding: String.Encoding.utf8) else {
            XCTFail("could not convert Data to String")
            return
        }
        
        XCTAssertTrue(boundStr == str)
    }
    
    func testValidStructBinding() {
        // swiftlint:disable:next nesting
        struct FooBar: Codable {
            var foo: Int
            var bar: Int
            
            init(_ foo: Int, _ bar: Int) {
                self.foo = foo
                self.bar = bar
            }
        }
        
        let foobarInput = InputCardDescriptor(
            name: "FooBar",
            subpath: nil,
            inputType: FooBar.self,
            inputDescription: "Foo! Bar!",
            assetCatalog: CardAssetCatalog())
        
        let card = foobarInput.makeCard()
        let foobarInstance = FooBar(1, 2)
        
        do {
            try card.bind(withValue: foobarInstance)
        } catch let error {
            XCTFail("error binding struct FooBar to FooBar card: \(error)")
            return
        }
        
        guard let value: FooBar = card.boundValue() else {
            XCTFail("could not get boundValue() as type FooBar")
            return
        }
        
        XCTAssertTrue(value.foo == foobarInstance.foo)
        XCTAssertTrue(value.bar == foobarInstance.bar)
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
