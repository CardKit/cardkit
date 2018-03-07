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

class CardDescriptorTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDescriptorIdentity() {
        let noActionA = CKTestCards.Action.NoAction
        let noActionB = CKTestCards.Action.NoAction
        XCTAssertTrue(noActionA == noActionB)
        XCTAssertFalse(noActionA != noActionB)
    }
    
    func testDescriptorEquality() {
        let a1 = ActionCardDescriptor(name: "A", subpath: nil, inputs: nil, tokens: nil, yields: nil, yieldDescription: nil, ends: true, endsDescription: nil, assetCatalog: CardAssetCatalog())
        let a2 = ActionCardDescriptor(name: "A", subpath: nil, inputs: nil, tokens: nil, yields: nil, yieldDescription: nil, ends: true, endsDescription: nil, assetCatalog: CardAssetCatalog())
        
        let d1 = DeckCardDescriptor(name: "A", subpath: nil, assetCatalog: CardAssetCatalog())
        let d2 = DeckCardDescriptor(name: "A", subpath: nil, assetCatalog: CardAssetCatalog())
        
        let h1 = InputCardDescriptor(name: "A", subpath: nil, inputType: Double.self, inputDescription: "", assetCatalog: CardAssetCatalog())
        let h2 = InputCardDescriptor(name: "A", subpath: nil, inputType: Double.self, inputDescription: "", assetCatalog: CardAssetCatalog())
        
        let i1 = HandCardDescriptor(name: "A", subpath: nil, handCardType: .branch, assetCatalog: CardAssetCatalog())
        let i2 = HandCardDescriptor(name: "A", subpath: nil, handCardType: .branch, assetCatalog: CardAssetCatalog())
        
        let t1 = TokenCardDescriptor(name: "A", subpath: nil, isConsumed: false, assetCatalog: CardAssetCatalog())
        let t2 = TokenCardDescriptor(name: "A", subpath: nil, isConsumed: false, assetCatalog: CardAssetCatalog())
        
        XCTAssertTrue(a1 == a2)
        XCTAssertTrue(d1 == d2)
        XCTAssertTrue(h1 == h2)
        XCTAssertTrue(i1 == i2)
        XCTAssertTrue(t1 == t2)
    }
    
    func testDescriptorPathInequality() {
        let a1 = ActionCardDescriptor(name: "A", subpath: nil, inputs: nil, tokens: nil, yields: nil, yieldDescription: nil, ends: true, endsDescription: nil, assetCatalog: CardAssetCatalog())
        let a2 = ActionCardDescriptor(name: "A", subpath: "A", inputs: nil, tokens: nil, yields: nil, yieldDescription: nil, ends: true, endsDescription: nil, assetCatalog: CardAssetCatalog())
        
        let d1 = DeckCardDescriptor(name: "A", subpath: nil, assetCatalog: CardAssetCatalog())
        let d2 = DeckCardDescriptor(name: "A", subpath: "A", assetCatalog: CardAssetCatalog())
        
        let h1 = InputCardDescriptor(name: "A", subpath: nil, inputType: Double.self, inputDescription: "", assetCatalog: CardAssetCatalog())
        let h2 = InputCardDescriptor(name: "A", subpath: "A", inputType: Double.self, inputDescription: "", assetCatalog: CardAssetCatalog())
        
        let i1 = HandCardDescriptor(name: "A", subpath: nil, handCardType: .branch, assetCatalog: CardAssetCatalog())
        let i2 = HandCardDescriptor(name: "A", subpath: "A", handCardType: .branch, assetCatalog: CardAssetCatalog())
        
        let t1 = TokenCardDescriptor(name: "A", subpath: nil, isConsumed: false, assetCatalog: CardAssetCatalog())
        let t2 = TokenCardDescriptor(name: "A", subpath: "A", isConsumed: false, assetCatalog: CardAssetCatalog())
        
        XCTAssertTrue(a1 != a2)
        XCTAssertTrue(d1 != d2)
        XCTAssertTrue(h1 != h2)
        XCTAssertTrue(i1 != i2)
        XCTAssertTrue(t1 != t2)
    }
    
    func testDescriptorSerialization() {
        let noAction = CKTestCards.Action.NoAction
        
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        do {
            let data = try encoder.encode(noAction)
            let decodedNoAction: ActionCardDescriptor = try decoder.decode(ActionCardDescriptor.self, from: data)
            XCTAssertTrue(noAction == decodedNoAction)
        } catch let error {
            XCTFail("error: \(error)")
        }
    }
}
