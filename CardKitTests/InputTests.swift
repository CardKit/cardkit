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
