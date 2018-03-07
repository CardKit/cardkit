/**
 * Copyright 2018 IBM Corp. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

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
