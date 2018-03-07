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
        let d: Deck = Deck()
        
        let h1: Hand = Hand()
        let h2: Hand = Hand()
        
        d.deckHands.append(h1)
        d.deckHands.append(h2)
        
        let encoder = JSONEncoder()
        
        do {
            let data = try encoder.encode(d)
            guard let str = String(data: data, encoding: .utf8) else {
                XCTFail("could not convert Data to UTF-8 string")
                return
            }
            print("\(str)")
        } catch let error {
            XCTFail("\(error)")
        }
        
        XCTAssertTrue(true)
    }
    
}
