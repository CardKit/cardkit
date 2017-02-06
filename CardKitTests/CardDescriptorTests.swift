//
//  CardDescriptorTests.swift
//  CardKit
//
//  Created by Justin Weisz on 8/3/16.
//  Copyright © 2016 IBM. All rights reserved.
//

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
    
    func testDescriptorToAndFromJSON() {
        let noAction = CKTestCards.Action.NoAction
        let jsonNoAction = noAction.toJSON()
        
        do {
            let noActionFromJSON = try ActionCardDescriptor(json: jsonNoAction)
            XCTAssertTrue(noAction == noActionFromJSON)
        } catch let error {
            XCTFail("error: \(error)")
        }
    }
}
