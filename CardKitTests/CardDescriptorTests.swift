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
    
    func testDescriptorIdentity() {
        let noActionA = CKTests.Action.NoAction
        let noActionB = CKTests.Action.NoAction
        XCTAssertTrue(noActionA == noActionB)
        XCTAssertFalse(noActionA != noActionB)
    }
    
    func testDescriptorEquality() {
        let a1 = ActionCardDescriptor(name: "A", subpath: nil, inputs: nil, tokens: nil, yields: nil, yieldDescription: nil, ends: true, endsDescription: "", assetCatalog: CardAssetCatalog(), version: 0)
        let a2 = ActionCardDescriptor(name: "A", subpath: nil, inputs: nil, tokens: nil, yields: nil, yieldDescription: nil, ends: true, endsDescription: "", assetCatalog: CardAssetCatalog(), version: 0)
        
        let d1 = DeckCardDescriptor(name: "A", subpath: nil, assetCatalog: CardAssetCatalog(), version: 0)
        let d2 = DeckCardDescriptor(name: "A", subpath: nil, assetCatalog: CardAssetCatalog(), version: 0)
        
        let h1 = InputCardDescriptor(name: "A", subpath: nil, inputType: .SwiftDouble, inputDescription: "", assetCatalog: CardAssetCatalog(), version: 0)
        let h2 = InputCardDescriptor(name: "A", subpath: nil, inputType: .SwiftDouble, inputDescription: "", assetCatalog: CardAssetCatalog(), version: 0)
        
        let i1 = HandCardDescriptor(name: "A", subpath: nil, handCardType: .Branch, assetCatalog: CardAssetCatalog(), version: 0)
        let i2 = HandCardDescriptor(name: "A", subpath: nil, handCardType: .Branch, assetCatalog: CardAssetCatalog(), version: 0)
        
        let t1 = TokenCardDescriptor(name: "A", subpath: nil, isConsumed: false, assetCatalog: CardAssetCatalog(), version: 0)
        let t2 = TokenCardDescriptor(name: "A", subpath: nil, isConsumed: false, assetCatalog: CardAssetCatalog(), version: 0)
        
        XCTAssertTrue(a1 == a2)
        XCTAssertTrue(d1 == d2)
        XCTAssertTrue(h1 == h2)
        XCTAssertTrue(i1 == i2)
        XCTAssertTrue(t1 == t2)
    }
    
    func testDescriptorPathInequality() {
        let a1 = ActionCardDescriptor(name: "A", subpath: nil, inputs: nil, tokens: nil, yields: nil, yieldDescription: nil, ends: true, endsDescription: "", assetCatalog: CardAssetCatalog(), version: 0)
        let a2 = ActionCardDescriptor(name: "A", subpath: "A", inputs: nil, tokens: nil, yields: nil, yieldDescription: nil, ends: true, endsDescription: "", assetCatalog: CardAssetCatalog(), version: 0)
        
        let d1 = DeckCardDescriptor(name: "A", subpath: nil, assetCatalog: CardAssetCatalog(), version: 0)
        let d2 = DeckCardDescriptor(name: "A", subpath: "A", assetCatalog: CardAssetCatalog(), version: 0)
        
        let h1 = InputCardDescriptor(name: "A", subpath: nil, inputType: .SwiftDouble, inputDescription: "", assetCatalog: CardAssetCatalog(), version: 0)
        let h2 = InputCardDescriptor(name: "A", subpath: "A", inputType: .SwiftDouble, inputDescription: "", assetCatalog: CardAssetCatalog(), version: 0)
        
        let i1 = HandCardDescriptor(name: "A", subpath: nil, handCardType: .Branch, assetCatalog: CardAssetCatalog(), version: 0)
        let i2 = HandCardDescriptor(name: "A", subpath: "A", handCardType: .Branch, assetCatalog: CardAssetCatalog(), version: 0)
        
        let t1 = TokenCardDescriptor(name: "A", subpath: nil, isConsumed: false, assetCatalog: CardAssetCatalog(), version: 0)
        let t2 = TokenCardDescriptor(name: "A", subpath: "A", isConsumed: false, assetCatalog: CardAssetCatalog(), version: 0)
        
        XCTAssertTrue(a1 != a2)
        XCTAssertTrue(d1 != d2)
        XCTAssertTrue(h1 != h2)
        XCTAssertTrue(i1 != i2)
        XCTAssertTrue(t1 != t2)
    }
    
    func testDescriptorVersionInequality() {
        let a1 = ActionCardDescriptor(name: "A", subpath: nil, inputs: nil, tokens: nil, yields: nil, yieldDescription: nil, ends: true, endsDescription: "", assetCatalog: CardAssetCatalog(), version: 0)
        let a2 = ActionCardDescriptor(name: "A", subpath: nil, inputs: nil, tokens: nil, yields: nil, yieldDescription: nil, ends: true, endsDescription: "", assetCatalog: CardAssetCatalog(), version: 1)
        
        let d1 = DeckCardDescriptor(name: "A", subpath: nil, assetCatalog: CardAssetCatalog(), version: 0)
        let d2 = DeckCardDescriptor(name: "A", subpath: nil, assetCatalog: CardAssetCatalog(), version: 1)
        
        let h1 = InputCardDescriptor(name: "A", subpath: nil, inputType: .SwiftDouble, inputDescription: "", assetCatalog: CardAssetCatalog(), version: 0)
        let h2 = InputCardDescriptor(name: "A", subpath: nil, inputType: .SwiftDouble, inputDescription: "", assetCatalog: CardAssetCatalog(), version: 1)
        
        let i1 = HandCardDescriptor(name: "A", subpath: nil, handCardType: .Branch, assetCatalog: CardAssetCatalog(), version: 0)
        let i2 = HandCardDescriptor(name: "A", subpath: nil, handCardType: .Branch, assetCatalog: CardAssetCatalog(), version: 1)
        
        let t1 = TokenCardDescriptor(name: "A", subpath: nil, isConsumed: false, assetCatalog: CardAssetCatalog(), version: 0)
        let t2 = TokenCardDescriptor(name: "A", subpath: nil, isConsumed: false, assetCatalog: CardAssetCatalog(), version: 1)
        
        XCTAssertTrue(a1 != a2)
        XCTAssertTrue(d1 != d2)
        XCTAssertTrue(h1 != h2)
        XCTAssertTrue(i1 != i2)
        XCTAssertTrue(t1 != t2)
    }
    
    func testDescriptorToAndFromJSON() {
        let noAction = CKTests.Action.NoAction
        let jsonNoAction = noAction.toJSON()
        
        do {
            let noActionFromJSON = try ActionCardDescriptor(json: jsonNoAction)
            XCTAssertTrue(noAction == noActionFromJSON)
        } catch let error {
            XCTFail("error: \(error)")
        }
    }
}
